CLASS lhc_CarParts DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF parts_status,
        inProgress TYPE c LENGTH 1  VALUE 'I', " In Progress
        received   TYPE c LENGTH 1  VALUE 'R', " Received
        canceled   TYPE c LENGTH 1  VALUE 'X', " Canceled
      END OF parts_status.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR CarParts RESULT result.

    METHODS calculateCarpartId FOR DETERMINE ON MODIFY
      IMPORTING keys FOR CarParts~calculateCarpartId.

    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR CarParts~calculateTotalPrice.

    METHODS setInitialStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR CarParts~setInitialStatus.

    METHODS validateReceiveDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR CarParts~validateReceiveDate.

    METHODS rejectOrder FOR MODIFY
      IMPORTING keys FOR ACTION CarParts~rejectOrder RESULT result.

    METHODS confirmOrder FOR MODIFY
      IMPORTING keys FOR ACTION CarParts~confirmOrder RESULT result.
    METHODS calculateOrderPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR CarParts~calculateOrderPrice.

ENDCLASS.

CLASS lhc_CarParts IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zdar_i_cars IN LOCAL MODE
    ENTITY CarParts
    FIELDS ( Status ) WITH CORRESPONDING #( keys )
    RESULT DATA(carparts).

    result = VALUE #( FOR carpart IN carparts
                        LET is_received = COND #( WHEN carpart-Status = parts_status-received
                                                  THEN if_abap_behv=>fc-o-disabled
                                                  ELSE if_abap_behv=>fc-o-enabled )
                            is_canceled = COND #( WHEN carpart-Status = parts_status-canceled
                                                  THEN if_abap_behv=>fc-o-disabled
                                                  ELSE if_abap_behv=>fc-o-enabled )
                        IN ( %tky = carpart-%tky
                             %action-confirmOrder = is_received
                             %action-rejectOrder = is_canceled ) ).

  ENDMETHOD.

  METHOD calculateCarpartId.
    DATA max_carpartid TYPE numc4.
    DATA update TYPE TABLE FOR UPDATE zdar_i_cars\\CarParts.

    " Read all cars for the requested parts.
    " If multiple parts of the same car are requested, the car is returned only once.
    READ ENTITIES OF zdar_i_cars IN LOCAL MODE
    ENTITY CarParts BY \_Car
      FIELDS ( CarUUID )
      WITH CORRESPONDING #( keys )
      RESULT DATA(cars).

    " Process all affected cars. Read respective parts, determine the max-id and update the parts without ID.
    LOOP AT cars INTO DATA(car).
      READ ENTITIES OF zdar_i_cars IN LOCAL MODE
        ENTITY Car BY \_CarParts
          FIELDS ( CarpartId )
        WITH VALUE #( ( %tky = car-%tky ) )
        RESULT DATA(carparts).

      " Find max used CarpartId in all parts of this car
      max_carpartid ='0000'.
      LOOP AT carparts INTO DATA(carpart).
        IF carpart-CarpartId > max_carpartid.
          max_carpartid = carpart-CarpartId.
        ENDIF.
      ENDLOOP.

      " Provide a CarpartId for all parts that have none.
      LOOP AT carparts INTO carpart WHERE CarpartId IS INITIAL.
        max_carpartid += 10.
        APPEND VALUE #( %tky      = carpart-%tky
                        CarpartId = max_carpartid
                      ) TO update.
      ENDLOOP.
    ENDLOOP.

    " Update the CarpartId of all relevant parts
    MODIFY ENTITIES OF zdar_i_cars IN LOCAL MODE
    ENTITY CarParts
      UPDATE FIELDS ( CarpartId ) WITH update
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD calculateTotalPrice.

    " Read all cars for the requested parts.
    " If multiple parts of the same car are requested, the car is returned only once.
    READ ENTITIES OF zdar_i_cars IN LOCAL MODE
    ENTITY CarParts BY \_Car
      FIELDS ( CarUUID )
      WITH CORRESPONDING #( keys )
      RESULT DATA(cars)
      FAILED DATA(read_failed).

    " Trigger calculation of the total price
    MODIFY ENTITIES OF zdar_i_cars IN LOCAL MODE
    ENTITY Car
      EXECUTE recalcTotalPrice
      FROM CORRESPONDING #( cars )
    REPORTED DATA(execute_reported).

    reported = CORRESPONDING #( DEEP execute_reported ).

  ENDMETHOD.

  METHOD setInitialStatus.
    MODIFY ENTITIES OF zdar_i_cars IN LOCAL MODE
    ENTITY CarParts
    UPDATE FIELDS ( Status ) WITH VALUE #( FOR key IN keys ( %tky            = key-%tky
                                                             Status          = parts_status-inProgress
                                                             %control-Status = if_abap_behv=>mk-on ) )
    REPORTED DATA(updates_status).

    reported = CORRESPONDING #( DEEP updates_status ).

  ENDMETHOD.

  METHOD validateReceiveDate.

    READ ENTITIES OF zdar_i_cars IN LOCAL MODE
    ENTITY CarParts
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(CarParts).

    READ ENTITIES OF zdar_i_cars IN LOCAL MODE
    ENTITY CarParts BY \_Car
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(Cars).

    APPEND VALUE #( %tky = Cars[ 1 ]-%tky
                  %state_area        = 'VALIDATE_RECEIVE_DATE' )
                  TO reported-car.

    LOOP AT CarParts ASSIGNING FIELD-SYMBOL(<fs_carpart>).
      IF <fs_carpart>-ReceiveDate <= <fs_carpart>-OrderDate OR <fs_carpart>-ReceiveDate IS INITIAL.
        APPEND VALUE #( %tky = <fs_carpart>-%tky ) TO failed-carparts.

        MESSAGE e004(zdar_rap_cars_msg) WITH <fs_carpart>-CarPartId INTO DATA(dummy).

        APPEND VALUE #( %tky = Cars[ 1 ]-%tky
                  %state_area        = 'VALIDATE_RECEIVE_DATE'
                  %msg = NEW zcl_dar_cm( severity = if_abap_behv_message=>severity-error
                                         textid = VALUE #( msgid = sy-msgid
                                                           msgno = sy-msgno
                                                           attr1 = sy-msgv1
                                                           ) ) )
                                                           TO reported-car.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD rejectOrder.

    " Set the new overall status
    MODIFY ENTITIES OF zdar_i_cars IN LOCAL MODE
      ENTITY CarParts
         UPDATE
           FIELDS ( Status )
           WITH VALUE #( FOR key IN keys
                           ( %tky           = key-%tky
                             Status         = parts_status-canceled ) )
      FAILED failed
      REPORTED reported.

    " Fill the response table
    READ ENTITIES OF zdar_i_cars IN LOCAL MODE
      ENTITY CarParts
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(carparts).

    result = VALUE #( FOR carpart IN carparts
                        ( %tky   = carpart-%tky
                          %param = carpart ) ).

    "MODIFY ENTITIES OF zdar_i_cars IN LOCAL MODE
    "ENTITY CarParts
    "UPDATE FIELDS ( Status ) WITH VALUE #( FOR key IN keys
    "                                         ( %tky            = key-%tky
    "                                           Status          = parts_status-canceled
    "                                           %control-Status = if_abap_behv=>mk-on ) )
    "REPORTED DATA(updates_status).
    "reported = CORRESPONDING #( DEEP updates_status ).

  ENDMETHOD.

  METHOD confirmOrder.

    " Set the new overall status
    MODIFY ENTITIES OF zdar_i_cars IN LOCAL MODE
      ENTITY CarParts
         UPDATE
           FIELDS ( Status )
           WITH VALUE #( FOR key IN keys
                           ( %tky          = key-%tky
                             Status        = parts_status-received
                             "ReceiveDate   = cl_abap_context_info=>get_system_date( )
                             ) )
      FAILED failed
      REPORTED reported.

    " Fill the response table
    READ ENTITIES OF zdar_i_cars IN LOCAL MODE
      ENTITY CarParts
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(carparts).

    result = VALUE #( FOR carpart IN carparts
                        ( %tky   = carpart-%tky
                          %param = carpart ) ).

  ENDMETHOD.

  METHOD calculateOrderPrice.

      " Read all associated bookings and add them to the total price.
      READ ENTITIES OF zdar_i_cars IN LOCAL MODE
        ENTITY CarParts
          FIELDS ( Amount OrderPrice CurrencyCode )
            WITH CORRESPONDING #( keys )
        RESULT DATA(carparts).


      " write back the modified total_price of cars
      "MODIFY ENTITIES OF zdar_i_cars IN LOCAL MODE
      "ENTITY carparts
      "  UPDATE FIELDS ( OrderPrice )
      "  WITH CORRESPONDING #( carparts ).

      LOOP AT carparts ASSIGNING FIELD-SYMBOL(<fs_carpart>).
        <fs_carpart>-OrderPrice = <fs_carpart>-Amount * <fs_carpart>-PartPrice.
      ENDLOOP.



    "MODIFY ENTITIES OF zdar_i_cars IN LOCAL MODE
    "  ENTITY CarParts
    "    UPDATE FIELDS ( OrderPrice ) WITH VALUE #( FOR key IN keys
    "                                                 ( %tky             = key-%tky
    "                                                   OrderPrice       = 5
    "                                                   %control         = VALUE #( OrderPrice = if_abap_behv=>mk-on ) ) )
    "    REPORTED DATA(updates_price).


    " write back the modified total_price of cars
    MODIFY ENTITIES OF zdar_i_cars IN LOCAL MODE
      ENTITY CarParts
        UPDATE FIELDS ( OrderPrice )
        WITH CORRESPONDING #( carparts ).

    "MODIFY ENTITIES OF zdar_i_cars IN LOCAL MODE
    "ENTITY CarParts
    "UPDATE FIELDS ( Status ) WITH VALUE #( FOR key IN keys
    "                                         ( %tky            = key-%tky
    "                                           Status          = parts_status-canceled
    "                                           %control-Status = if_abap_behv=>mk-on ) )
    "REPORTED DATA(updates_status).
    "reported = CORRESPONDING #( DEEP updates_status ).

    "reported = CORRESPONDING #( DEEP updates_price ).

  ENDMETHOD.

ENDCLASS.
