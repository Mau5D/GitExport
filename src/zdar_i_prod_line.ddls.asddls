@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Line View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZDAR_I_PROD_LINE
  as select from zdar_prod_line as ProdLine
  association        to parent ZDAR_I_CARS as _Car   on $projection.Caruuid = _Car.Caruuid
  association [0..1] to ZDAR_I_STATUS      as _Status on $projection.Status = _Status.Status
{
  key vin                   as Vin,
      caruuid               as Caruuid,
      start_date            as StartDate,
      end_date              as EndDate,
      status                as Status,
      description           as Description,
      @Semantics.user.lastChangedBy: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      /* associations */
      _Car,
      _Status
}
