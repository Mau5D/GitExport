CLASS zcl_dar_generate_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_dar_generate_data IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA:
      lt_cars      TYPE TABLE OF zdar_cars,
      lt_carparts  TYPE TABLE OF zdar_carparts,
      lt_manuf     TYPE TABLE OF zdar_manufactr,
      lt_inventory TYPE TABLE OF zdar_inventory,
      lt_status    TYPE TABLE OF zdar_status.


*    lt_cars = VALUE #( ( client = '100' caruuid = '5254004BA7031ED991E17ABE38EC6354' car_id = '0001' car_brand = 'Citroen' car_model = 'C3'
*    total_price = '10000.00' currency_code = 'EUR' start_date = '20220626' end_date = '20230424' overall_status = 'O'
*    created_by = 'MDARASHKOU' created_at = '20220530135858.0000000' last_changed_by = 'MDARASHKOU' last_changed_at = '20220922171106.8189310' local_last_changed_at = '20220922171106.8189310') ).
*
*    lt_carparts = VALUE #( ( client = '100' carparts_uuid = '5254004BA7031EDD88F0D305DB124B45' car_uuid = '5254004BA7031ED991E17ABE38EC6354' carpart_id = '0001'
*    carpart_name = 'ABS' amount = '100' order_date = '20220626' status = 'O'
*    manufacturer_id = '1' receive_date = '20230424' order_price = '5000.00' currency_code = 'EUR' created_by = 'MDARASHKOU'
*    last_changed_by = 'MDARASHKOU' local_last_changed_at = '20220922171106.8189310') ).
*
*    lt_manuf = VALUE #( ( client = '100' manufacturer_id = '0001' name = 'BOSCH' street = 'street1' postal_code = '101' city = 'Frankfurt' country_code = 'DE' phone_number = '+2676233223' email_address = 'abc@gmail.com'
*    part_name = 'ABS' price = '100.00' currency_code = 'EUR' created_by = 'MDARASHKOU' last_changed_by = 'MDARASHKOU' local_last_changed_at = '20220922171106.8189310')
*                        ( client = '100' manufacturer_id = '0002' name = 'Varta' street = 'street2' postal_code = '111' city = 'Berlin' country_code = 'DE' phone_number = '+2676232223' email_address = 'def@gmail.com'
*    part_name = 'Battery' price = '50.00' currency_code = 'EUR' created_by = 'MDARASHKOU' last_changed_by = 'MDARASHKOU' local_last_changed_at = '20220922171106.8189310')
*                        ( client = '100' manufacturer_id = '0003' name = 'Brembo' street = 'street3' postal_code = '121' city = 'Stuttgart' country_code = 'DE' phone_number = '+2644233223' email_address = 'ghi@gmail.com'
*    part_name = 'Brake Callipers' price = '150.00' currency_code = 'EUR' created_by = 'MDARASHKOU' last_changed_by = 'MDARASHKOU' local_last_changed_at = '20220922171106.8189310') ).
*
*    lt_status = VALUE #( ( client = '100' status = 'O' description = 'Open' )
*                         ( client = '100' status = 'R' description = 'Received' )
*                         ( client = '100' status = 'X' description = 'Canceled' )
*                         ( client = '100' status = 'A' description = 'Accepted' )
*                         ( client = '100' status = 'D' description = 'Done' )
*                         ( client = '100' status = 'I' description = 'In Progress' ) ).
*
*
*    " 20220626 ; 20230424 ;120.00 ;5376.00 ;USD;Thangam Test;O;Neubasler;20220530135858.0000000 ;CB9980000740;20220922171106.8189310 ;20220922171106.8189310


    lt_manuf = VALUE #(
    ( client = '100' manufacturer_id = '0001' manufacturer_name = 'Toyo Tires' supported_brand = 'Audi' part_name = 'Tires' amount = '4' price = '1500.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0002' manufacturer_name = 'Yokohama' supported_brand = 'Toyota' part_name = 'Tires' amount = '4' price = '2000.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0003' manufacturer_name = 'Hankook' supported_brand = 'BMW' part_name = 'Tires' amount = '4' price = '3000.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0004' manufacturer_name = 'Michelin' supported_brand = 'VW' part_name = 'Tires' amount = '4' price = '2300.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0005' manufacturer_name = 'Belshina' supported_brand = 'Geely' part_name = 'Tires' amount = '4' price = '1100.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0006' manufacturer_name = 'BOSCH' supported_brand = 'Audi' part_name = 'Brake System' amount = '4' price = '210.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0007' manufacturer_name = 'Brembo' supported_brand = 'BMW' part_name = 'Brake System' amount = '4' price = '230.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0008' manufacturer_name = 'Remsa' supported_brand = 'Toyota' part_name = 'Brake System' amount = '4' price = '170.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0009' manufacturer_name = 'Kortex' supported_brand = 'VW' part_name = 'Brake System' amount = '4' price = '220.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0010' manufacturer_name = 'Rixos' supported_brand = 'Geely' part_name = 'Brake System' amount = '4' price = '100.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0011' manufacturer_name = 'Nokian' supported_brand = 'Peugeot' part_name = 'Tyres' amount = '4' price = '1700.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0012' manufacturer_name = 'ATE' supported_brand = 'Peugeot' part_name = 'Brake System' amount = '4' price = '140.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0013' manufacturer_name = 'VW AG' supported_brand = 'Audi' part_name = 'Engine' amount = '1' price = '5000.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0014' manufacturer_name = 'Toyota' supported_brand = 'Toyota' part_name = 'Engine' amount = '1' price = '4500.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0015' manufacturer_name = 'BMW Group' supported_brand = 'BMW' part_name = 'Engine' amount = '1' price = '7000.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0016' manufacturer_name = 'VW AG' supported_brand = 'VW' part_name = 'Engine' amount = '1' price = '4200.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0017' manufacturer_name = 'Geely Automobile' supported_brand = 'Geely' part_name = 'Engine' amount = '1' price = '3200.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0018' manufacturer_name = 'Stelantis' supported_brand = 'Peugeot' part_name = 'Engine' amount = '1' price = '3700.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0019' manufacturer_name = 'BBS' supported_brand = 'Audi' part_name = 'Rims' amount = '4' price = '2000.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0020' manufacturer_name = '5-zigen' supported_brand = 'Toyota' part_name = 'Rims' amount = '4' price = '1900.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0021' manufacturer_name = 'Enkei' supported_brand = 'BMW' part_name = 'Rims' amount = '4' price = '4200.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0022' manufacturer_name = 'Konig' supported_brand = 'VW' part_name = 'Rims' amount = '4' price = '3200.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0023' manufacturer_name = 'OZ' supported_brand = 'Geely' part_name = 'Rims' amount = '4' price = '2200.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0024' manufacturer_name = 'Vossen' supported_brand = 'Peugeot' part_name = 'Rims' amount = '4' price = '1500.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0025' manufacturer_name = 'VW AG' supported_brand = 'Audi' part_name = 'Interior' amount = '1' price = '1200.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0026' manufacturer_name = 'Toyota' supported_brand = 'Toyota' part_name = 'Interior' amount = '1' price = '1000.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0027' manufacturer_name = 'BMW Group' supported_brand = 'BMW' part_name = 'Interior' amount = '1' price = '1500.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0028' manufacturer_name = 'VW AG' supported_brand = 'VW' part_name = 'Interior' amount = '1' price = '900.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0029' manufacturer_name = 'Geely Automobile' supported_brand = 'Geely' part_name = 'Interior' amount = '1' price = '700.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0030' manufacturer_name = 'Stelantis' supported_brand = 'Peugeot' part_name = 'Interior' amount = '1' price = '1000.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0031' manufacturer_name = 'VW AG' supported_brand = 'Audi' part_name = 'Lights' amount = '5' price = '200.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0032' manufacturer_name = 'BMW Group' supported_brand = 'BMW' part_name = 'Lights' amount = '5' price = '700.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0033' manufacturer_name = 'VW AG' supported_brand = 'VW' part_name = 'Lights' amount = '5' price = '150.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0034' manufacturer_name = 'Geely Automobile' supported_brand = 'Geely' part_name = 'Lights' amount = '5' price = '100.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0035' manufacturer_name = 'Stelantis' supported_brand = 'Peugeot' part_name = 'Lights' amount = '5' price = '110.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0036' manufacturer_name = 'Toyota' supported_brand = 'Toyota' part_name = 'Lights' amount = '5' price = '120.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0037' manufacturer_name = 'VW AG' supported_brand = 'Audi' part_name = 'Autoelectronics' amount = '1' price = '1500.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0038' manufacturer_name = 'BMW Group' supported_brand = 'BMW' part_name = 'Autoelectronics' amount = '1' price = '1500.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0039' manufacturer_name = 'VW AG' supported_brand = 'VW' part_name = 'Autoelectronics' amount = '1' price = '1500.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0040' manufacturer_name = 'Toyota' supported_brand = 'Toyota' part_name = 'Autoelectronics' amount = '1' price = '1500.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0041' manufacturer_name = 'Geely Automobile' supported_brand = 'Geely' part_name = 'Autoelectronics' amount = '1' price = '1500.00' currency_code = 'EUR')
    ( client = '100' manufacturer_id = '0042' manufacturer_name = 'Stelantis' supported_brand = 'Peugeot' part_name = 'Autoelectronics' amount = '1' price = '1500.00' currency_code = 'EUR')
    ).

    DATA(lv_i) = '0001'.
    DO 42 TIMES.
      TRY.
          DATA(lv_uuid) = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
        CATCH cx_uuid_error INTO DATA(lo_error).
      ENDTRY.
      INSERT VALUE #( client = '100' component_uuid = lv_uuid remains = '100' manufacturer_id = lv_i ) INTO TABLE lt_inventory.
      lv_i += 1.
    ENDDO.

*      lt_inventory = VALUE #( ( client = '100' component_uuid = '5254004BA7031EDD88F0D305DB124B45' remains = '100' manufacturer_id = '0001') ).
*
*    DELETE FROM zdar_cars.
*    DELETE FROM zdar_carparts.
*    DELETE FROM zdar_complog.
    DELETE FROM zdar_manufactr.
    DELETE FROM zdar_inventory.
*    "DELETE FROM zdar_status.
*    "DELETE FROM zdar_workers.
*
*    "INSERT zdar_cars FROM TABLE @lt_cars.
*    "INSERT zdar_carparts FROM TABLE @lt_carparts.
    INSERT zdar_manufactr FROM TABLE @lt_manuf.
*    "INSERT zdar_status FROM TABLE @lt_status.
    INSERT zdar_inventory FROM TABLE @lt_inventory.

    "SELECT * FROM zdar_inventory INNER JOIN zdar_manufactr ON zdar_inventory~manufacturer_id = zdar_manufactr~manufacturer_id INTO TABLE @DATA(lt_inv_manuf).

    out->write( 'Done' ).

  ENDMETHOD.
ENDCLASS.
