@EndUserText.label: 'Production Line Consumption View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true

define view entity ZDAR_C_PROD_LINE
  as projection on ZDAR_I_PROD_LINE
{
      @Search.defaultSearchElement: true
  key Vin,
      Caruuid,
      StartDate,
      EndDate,
      Status,
      Description,
      LastChangedAt,
      LocalLastChangedAt,


      /* Associations */
      _Car : redirected to parent ZDAR_C_CARS,
      _Status
}
