@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Components Log View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZDAR_I_COMPLOG
  as select from zdar_complog as CompLog
  association to parent ZDAR_I_CARS as _Car on $projection.CarUuid = _Car.Caruuid
{
  key log_uuid              as LogUuid,
      car_uuid              as CarUuid,
      carpart_uuid          as CarpartUuid,
      status                as Status,
      message               as Message,
      local_last_changed_at as LocalLastChangedAt,

      /* associations */
      _Car
}
