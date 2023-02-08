CLASS lhc_Car DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF overall_status,
        open     TYPE c LENGTH 1  VALUE 'O', " Open
        accepted TYPE c LENGTH 1  VALUE 'A', " Accepted
        canceled TYPE c LENGTH 1  VALUE 'X', " Canceled
        done     TYPE c LENGTH 1  VALUE 'D', " Done
      END OF overall_status.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Car RESULT result.

    METHODS acceptCar FOR MODIFY
      IMPORTING keys FOR ACTION Car~acceptCar RESULT result.

    METHODS recalcTotalPrice FOR MODIFY
      IMPORTING keys FOR ACTION Car~recalcTotalPrice.

    METHODS rejectCar FOR MODIFY
      IMPORTING keys FOR ACTION Car~rejectCar RESULT result.

    METHODS setInitialStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Car~setInitialStatus.

    METHODS calculateCarID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Car~calculateCarID.

    METHODS validateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Car~validateDates.

ENDCLASS.

CLASS lhc_Car IMPLEMENTATION.

  METHOD get_instance_features.
    " Read the travel status of the existing travels
    READ ENTITIES OF zdar_i_cars IN LOCAL MODE
      ENTITY Car
        FIELDS ( OverallStatus ) WITH CORRESPONDING #( keys )
      RESULT DATA(cars)
      FAILED failed.

    result =
      VALUE #(
        FOR car IN cars
          LET is_accepted =   COND #( WHEN car-OverallStatus = overall_status-accepted
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled  )
              is_rejected =   COND #( WHEN car-OverallStatus = overall_status-canceled
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled )
          IN
            ( %tky                 = car-%tky
              %action-acceptCar    = is_accepted
              %action-rejectCar    = is_rejected
             ) ).
  ENDMETHOD.

  METHOD acceptCar.
    " Set the new overall status
    MODIFY ENTITIES OF zdar_i_cars IN LOCAL MODE
      ENTITY Car
         UPDATE
           FIELDS ( StartDate OverallStatus )
           WITH VALUE #( FOR key IN keys
                           ( %tky          = key-%tky
                             OverallStatus = overall_status-accepted
                             StartDate     = cl_abap_context_info=>get_system_date( ) ) )
      FAILED failed
      REPORTED reported.

    " Fill the response table
    READ ENTITIES OF zdar_i_cars IN LOCAL MODE
      ENTITY Car
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(cars).

    result = VALUE #( FOR car IN cars
                        ( %tky   = car-%tky
                          %param = car ) ).
  ENDMETHOD.

  METHOD recalcTotalPrice.
    TYPES: BEGIN OF ty_amount_per_currencycode,
             amount        TYPE /dmo/total_price,
             currency_code TYPE /dmo/currency_code,
           END OF ty_amount_per_currencycode.

    DATA: amount_per_currencycode TYPE STANDARD TABLE OF ty_amount_per_currencycode.

    " Read all relevant car instances.
    READ ENTITIES OF zdar_i_cars IN LOCAL MODE
         ENTITY Car
            FIELDS ( TotalPrice CurrencyCode )
            WITH CORRESPONDING #( keys )
         RESULT DATA(cars).

    DELETE cars WHERE CurrencyCode IS INITIAL.

    LOOP AT cars ASSIGNING FIELD-SYMBOL(<fs_car>).
      " Set the start for the calculation by adding the booking fee.
      amount_per_currencycode = VALUE #( ( amount        = 0 "<fs_car>-TotalPrice
                                           currency_code = <fs_car>-CurrencyCode ) ).

      " Read all associated bookings and add them to the total price.
      READ ENTITIES OF zdar_i_cars IN LOCAL MODE
        ENTITY Car BY \_CarParts
          FIELDS ( OrderPrice CurrencyCode )
        WITH VALUE #( ( %tky = <fs_car>-%tky ) )
        RESULT DATA(carparts).

      LOOP AT carparts INTO DATA(carpart) WHERE CurrencyCode IS NOT INITIAL.
        COLLECT VALUE ty_amount_per_currencycode( amount        = carpart-OrderPrice
                                                  currency_code = carpart-CurrencyCode ) INTO amount_per_currencycode.
      ENDLOOP.

      CLEAR <fs_car>-TotalPrice.
      LOOP AT amount_per_currencycode INTO DATA(single_amount_per_currencycode).
        " If needed do a Currency Conversion
        IF single_amount_per_currencycode-currency_code = <fs_car>-CurrencyCode.
          <fs_car>-TotalPrice += single_amount_per_currencycode-amount.
        ELSE.
          /dmo/cl_flight_amdp=>convert_currency(
             EXPORTING
               iv_amount                   =  single_amount_per_currencycode-amount
               iv_currency_code_source     =  single_amount_per_currencycode-currency_code
               iv_currency_code_target     =  <fs_car>-CurrencyCode
               iv_exchange_rate_date       =  cl_abap_context_info=>get_system_date( )
             IMPORTING
               ev_amount                   =  DATA(total_booking_price_per_curr)
            ).
          <fs_car>-TotalPrice += total_booking_price_per_curr.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    " write back the modified total_price of cars
    MODIFY ENTITIES OF zdar_i_cars IN LOCAL MODE
      ENTITY car
        UPDATE FIELDS ( TotalPrice )
        WITH CORRESPONDING #( cars ).

  ENDMETHOD.

  METHOD rejectCar.
    " Set the new overall status
    MODIFY ENTITIES OF zdar_i_cars IN LOCAL MODE
      ENTITY Car
         UPDATE
           FIELDS ( EndDate OverallStatus )
           WITH VALUE #( FOR key IN keys
                           ( %tky          = key-%tky
                             OverallStatus = overall_status-canceled
                             EndDate       = cl_abap_context_info=>get_system_date( ) ) )
      FAILED failed
      REPORTED reported.

    " Fill the response table
    READ ENTITIES OF zdar_i_cars IN LOCAL MODE
      ENTITY Car
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(cars).

    result = VALUE #( FOR car IN cars
                        ( %tky   = car-%tky
                          %param = car ) ).
  ENDMETHOD.

  METHOD setInitialStatus.
    " Read relevant car instance data
    READ ENTITIES OF zdar_i_cars IN LOCAL MODE
      ENTITY Car
        FIELDS ( OverallStatus ) WITH CORRESPONDING #( keys )
      RESULT DATA(cars).

    " Remove all car instance data with defined status
    DELETE cars WHERE OverallStatus IS NOT INITIAL.
    CHECK cars IS NOT INITIAL.

    " Set default car status
    MODIFY ENTITIES OF zdar_i_cars IN LOCAL MODE
    ENTITY Car
      UPDATE
        FIELDS ( OverallStatus )
        WITH VALUE #( FOR car IN cars
                      ( %tky         = car-%tky
                        OverallStatus = overall_status-open ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD calculateCarID.
    " check if CarID is already filled
    READ ENTITIES OF zdar_i_cars IN LOCAL MODE
      ENTITY Car
        FIELDS ( CarID ) WITH CORRESPONDING #( keys )
      RESULT DATA(cars).

    " remove lines where CarID is already filled.
    DELETE cars WHERE CarID IS NOT INITIAL.

    " anything left ?
    CHECK cars IS NOT INITIAL.

    " Select max car ID
    SELECT SINGLE
        FROM  zdar_cars
        FIELDS MAX( car_id ) AS carID
        INTO @DATA(max_carid).

    " Set the car ID
    MODIFY ENTITIES OF zdar_i_cars IN LOCAL MODE
    ENTITY Car
      UPDATE
        FROM VALUE #( FOR car IN cars INDEX INTO i (
          %tky           = car-%tky
          CarID          = max_carid + i
          %control-CarID = if_abap_behv=>mk-on ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD validateDates.
    " Read relevant car instance data
    READ ENTITIES OF zdar_i_cars IN LOCAL MODE
      ENTITY Car
        FIELDS ( CarId StartDate EndDate ) WITH CORRESPONDING #( keys )
      RESULT DATA(cars).

    LOOP AT cars INTO DATA(car).
      " Clear state messages that might exist
      APPEND VALUE #(  %tky        = car-%tky
                       %state_area = 'VALIDATE_DATES' )
        TO reported-car.

      IF car-EndDate < car-StartDate.
        APPEND VALUE #( %tky = car-%tky ) TO failed-car.
        APPEND VALUE #( %tky               = car-%tky
                        %state_area        = 'VALIDATE_DATES'
                        %msg               = NEW zcl_dar_cm(
                                                 severity  = if_abap_behv_message=>severity-error
                                                 textid    = zcl_dar_cm=>date_interval
                                                 startdate = car-StartDate
                                                 enddate   = car-EndDate
                                                 carid     = car-CarId )
                        %element-StartDate = if_abap_behv=>mk-on
                        %element-EndDate   = if_abap_behv=>mk-on ) TO reported-car.

      ELSEIF car-StartDate < cl_abap_context_info=>get_system_date( ).
        APPEND VALUE #( %tky               = car-%tky ) TO failed-car.
        APPEND VALUE #( %tky               = car-%tky
                        %state_area        = 'VALIDATE_DATES'
                        %msg               = NEW zcl_dar_cm(
                                                 severity  = if_abap_behv_message=>severity-error
                                                 textid    = zcl_dar_cm=>begin_date_before_system_date
                                                 startdate = car-StartDate )
                        %element-StartDate = if_abap_behv=>mk-on ) TO reported-car.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
