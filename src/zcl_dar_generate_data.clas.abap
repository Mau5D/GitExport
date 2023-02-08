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
      lt_cars     TYPE TABLE OF zdar_cars,
      lt_carparts TYPE TABLE OF zdar_carparts,
      lt_manuf    TYPE TABLE OF zdar_manufactr,
      lt_status   TYPE TABLE OF zdar_status.
      "lt_workers  TYPE TABLE OF zdar_workers.


    lt_cars = VALUE #( ( client = '100' caruuid = '5254004BA7031ED991E17ABE38EC6354' car_id = '0001' car_brand = 'Citroen' car_model = 'C3'
    total_price = '10000.00' currency_code = 'EUR' start_date = '20220626' end_date = '20230424' overall_status = 'O'
    created_by = 'MDARASHKOU' created_at = '20220530135858.0000000' last_changed_by = 'MDARASHKOU' last_changed_at = '20220922171106.8189310' local_last_changed_at = '20220922171106.8189310') ).

    lt_carparts = VALUE #( ( client = '100' carparts_uuid = '5254004BA7031EDD88F0D305DB124B45' car_uuid = '5254004BA7031ED991E17ABE38EC6354' carpart_id = '0001'
    carpart_name = 'ABS' amount = '100' order_date = '20220626' status = 'O'
    manufacturer_id = '1' receive_date = '20230424' order_price = '5000.00' currency_code = 'EUR' created_by = 'MDARASHKOU'
    last_changed_by = 'MDARASHKOU' local_last_changed_at = '20220922171106.8189310') ).

    lt_manuf = VALUE #( ( client = '100' manufacturer_id = '0001' name = 'BOSCH' street = 'street1' postal_code = '101' city = 'Frankfurt' country_code = 'DE' phone_number = '+2676233223' email_address = 'abc@gmail.com'
    part_name = 'ABS' price = '100.00' currency_code = 'EUR' created_by = 'MDARASHKOU' last_changed_by = 'MDARASHKOU' local_last_changed_at = '20220922171106.8189310')
                        ( client = '100' manufacturer_id = '0002' name = 'Varta' street = 'street2' postal_code = '111' city = 'Berlin' country_code = 'DE' phone_number = '+2676232223' email_address = 'def@gmail.com'
    part_name = 'Battery' price = '50.00' currency_code = 'EUR' created_by = 'MDARASHKOU' last_changed_by = 'MDARASHKOU' local_last_changed_at = '20220922171106.8189310')
                        ( client = '100' manufacturer_id = '0003' name = 'Brembo' street = 'street3' postal_code = '121' city = 'Stuttgart' country_code = 'DE' phone_number = '+2644233223' email_address = 'ghi@gmail.com'
    part_name = 'Brake Callipers' price = '150.00' currency_code = 'EUR' created_by = 'MDARASHKOU' last_changed_by = 'MDARASHKOU' local_last_changed_at = '20220922171106.8189310') ).

    lt_status = VALUE #( ( client = '100' status = 'O' description = 'Open' )
                         ( client = '100' status = 'R' description = 'Received' )
                         ( client = '100' status = 'X' description = 'Canceled' )
                         ( client = '100' status = 'A' description = 'Accepted' )
                         ( client = '100' status = 'D' description = 'Done' )
                         ( client = '100' status = 'I' description = 'In Progress' ) ).

    "lt_workers = VALUE #( ( client = '100' caruuid = '5254004BA7031ED991E17ABE38EC6354' name = 'Alex' surname = 'Ivanov' jobtitle = 'Test1' post = '11' phone = '+375259482274' mail = 'abc@gmail.com' )
    "                  ( client = '100' caruuid = '5254004BA7031ED991E17ABE38EC6354' name = 'Alex' surname = 'Sidorov' jobtitle = 'Test2'  post = '11' mail = 'def@gmail.com' )
    "                 ( client = '100' caruuid = '5254004BA7031ED991E17ABE38EC6354' name = 'Alex' surname = 'Petrov' jobtitle = 'Test3' post = '11' mail = 'ghi@gmail.com' ) ).


    " 20220626 ; 20230424 ;120.00 ;5376.00 ;USD;Thangam Test;O;Neubasler;20220530135858.0000000 ;CB9980000740;20220922171106.8189310 ;20220922171106.8189310


    "DELETE FROM zdar_cars.
    "DELETE FROM zdar_carparts.
    DELETE FROM zdar_manufactr.
    "DELETE FROM zdar_status.
    "DELETE FROM zdar_workers.

    "INSERT zdar_cars FROM TABLE @lt_cars.
    "INSERT zdar_carparts FROM TABLE @lt_carparts.
    INSERT zdar_manufactr FROM TABLE @lt_manuf.
    "INSERT zdar_status FROM TABLE @lt_status.
    "INSERT zdar_workers FROM TABLE @lt_workers.

    out->write( 'Done' ).

  ENDMETHOD.

ENDCLASS.
