@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Brand Field'

define view entity ZDAR_VH_CAR_ID
  as select from ZDAR_I_CARS
{
      @ObjectModel.text.element: ['CarBrand']
      @Search: { defaultSearchElement: true,
                 fuzzinessThreshold: 0.9,
                 ranking: #HIGH }
      @EndUserText.label: 'Car Id'
  key CarId,

      @Semantics.text: true
      @Search: { defaultSearchElement: true,
                 fuzzinessThreshold: 0.9,
                 ranking: #HIGH }
      @EndUserText.label: 'Car Brand'
      CarBrand
}
group by
  CarId,
  CarBrand
