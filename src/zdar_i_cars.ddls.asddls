@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Cars View'

define root view entity ZDAR_I_CARS
  as select from zdar_cars as Car
  composition [0..*] of ZDAR_I_CARPARTS as _CarParts
  composition [0..*] of ZDAR_I_PROD_LINE as _ProdLine
  composition [0..*] of ZDAR_I_COMPLOG as _Log
  //association        to ZDAR_VH_CAR_ID         as _CarIdVH    on $projection.CarId = _CarIdVH.CarId
  //association        to ZDAR_VH_CAR_BRAND      as _CarBrandVH on $projection.CarId = _CarBrandVH.CarId
  //association [0..1] to I_Currency             as _Currency          on $projection.CurrencyCode = _Currency.Currency
  association [0..1] to ZDAR_I_STATUS   as _Status on $projection.OverallStatus = _Status.Status
{
  key caruuid               as Caruuid,
      car_id                as CarId,
      car_brand             as CarBrand,
      car_model             as CarModel,
      car_type              as CarType,
      amount                as Amount,
      priority              as Priority,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_price           as TotalPrice,
      currency_code         as CurrencyCode,
      //description           as Description,
      start_date            as StartDate,
      end_date              as EndDate,
      overall_status        as OverallStatus,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      /* associations */
      _CarParts,
      _ProdLine,
      _Log,
      _Status
      //_CarIdVH,
      //_CarBrandVH,
      //_Currency
}
