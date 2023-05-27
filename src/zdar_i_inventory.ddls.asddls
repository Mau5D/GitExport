@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invenory View'
@Search.searchable: true
define view entity ZDAR_I_INVENTORY
  as select from zdar_inventory as Inventory
  association [0..1] to ZDAR_I_MANUFACTR as _Manuf on $projection.ManufacturerId = _Manuf.ManufacturerId
{
      @Search.defaultSearchElement: true
  key component_uuid  as ComponentUuid,
      //carpart_name    as CarpartName,
      remains         as Remains,
      //order_date      as OrderDate,
      manufacturer_id as ManufacturerId,
      _Manuf.PartName as PartName,
      

      /* Associations */
      _Manuf
}
