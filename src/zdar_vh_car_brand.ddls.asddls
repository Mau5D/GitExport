@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Brand Field'
@Search.searchable: true

define view entity ZDAR_VH_CAR_BRAND
  as select from ZDAR_I_CARS
{
      @Semantics.text: true
      @Search: { defaultSearchElement: true,
                 fuzzinessThreshold: 0.9,
                 ranking: #HIGH }
      @EndUserText.label: 'Car Brand'
  key CarBrand,
      @ObjectModel.text.element: ['CarId']
      @Semantics.text: true
      @Search: { defaultSearchElement: true,
                 fuzzinessThreshold: 0.9,
                 ranking: #HIGH }
      @EndUserText.label: 'Car Id'
      CarId,
      @EndUserText.label: 'Car Model'
      CarModel
}
