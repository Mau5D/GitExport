@EndUserText.label: 'Projection Cars View'
@AccessControl.authorizationCheck: #NOT_ALLOWED
@Search.searchable: true
@Metadata.allowExtensions: true

define root view entity ZDAR_C_CARS
  as projection on ZDAR_I_CARS as Cars
{
  key Caruuid,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZDAR_VH_CAR_ID', element: 'CarId'} }]
      @ObjectModel.text.element: ['CarBrand']
      CarId,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZDAR_VH_CAR_BRAND', element: 'CarBrand'} }]
      @Semantics.text: true
      CarBrand,
      CarModel,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Currency', element: 'Currency'} }]
      CurrencyCode,
      StartDate,
      EndDate,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZDAR_I_STATUS', element: 'Status'} }]
      OverallStatus,
      _Status.Description as Description,
      LastChangedAt,
      LocalLastChangedAt,


      /* associations */
      _CarParts : redirected to composition child ZDAR_C_CARPARTS,
      _Status
      //_Currency

}
