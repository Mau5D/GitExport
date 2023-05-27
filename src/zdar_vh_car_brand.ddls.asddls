@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Brand Field'
@Search.searchable: true

define view entity ZDAR_VH_CAR_BRAND
  as select from ZDAR_I_MANUFACTR
{
      @Semantics.text: true
      @Search: { defaultSearchElement: true,
                 fuzzinessThreshold: 0.9,
                 ranking: #HIGH }
      @EndUserText.label: 'Car Brand'
  key SuppBrand
}
