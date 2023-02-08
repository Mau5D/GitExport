@EndUserText.label: 'Projection Car Parts View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true

define view entity ZDAR_C_CARPARTS
  as projection on ZDAR_I_CARPARTS
{
  key CarpartsUuid,
      CarUuid,
      @Search.defaultSearchElement: true
      CarpartId,
      CarpartName,
      OrderDate,
      Amount,
      @Consumption.valueHelpDefinition: [ {entity: {name: 'ZDAR_I_MANUFACTR', element: 'ManufacturerId'},
                                           additionalBinding: [ { localElement: 'CarpartName',   element: 'PartName',   usage: #RESULT},
                                                                { localElement: 'ManufName',   element: 'Name',   usage: #RESULT},
                                                                { localElement: 'PartPrice',  element: 'Price',        usage: #RESULT },
                                                                { localElement: 'CurrencyCode', element: 'CurrencyCode', usage: #RESULT } ] } ]
      @Search.defaultSearchElement: true
      ManufacturerId,
      _Manuf.Name         as ManufName,
      ReceiveDate,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZDAR_I_STATUS', element: 'Status' } }]
      Status,
      Criticality,
      _Status.Description as Description,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      PartPrice,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      OrderPrice,
      @Consumption.valueHelpDefinition: [{ entity: {name: 'I_Currency', element: 'Currency' } }]
      CurrencyCode,
      CreatedBy,
      LocalLastChangedAt,

      /* Associations */
      _Car : redirected to parent ZDAR_C_CARS,
      _Status,
      _Manuf
}
