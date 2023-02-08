@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Car Parts View'

define view entity ZDAR_I_CARPARTS
  as select from zdar_carparts as CarParts
  association        to parent ZDAR_I_CARS as _Car    on $projection.CarUuid = _Car.Caruuid
  //association [0..1] to I_Currency         as _Currency on $projection.CurrencyCode = _Currency.Currency
  association [1..1] to ZDAR_I_MANUFACTR   as _Manuf  on $projection.ManufacturerId = _Manuf.ManufacturerId
  association [0..1] to ZDAR_I_STATUS      as _Status on $projection.Status = _Status.Status
{
  key carparts_uuid         as CarpartsUuid,
      car_uuid              as CarUuid,
      carpart_id            as CarpartId,
      carpart_name          as CarpartName,
      order_date            as OrderDate,
      amount                as Amount,
      manufacturer_id       as ManufacturerId,
      receive_date          as ReceiveDate,
      status                as Status,
      case status
        when 'O' then 0 // grey
        when 'I' then 0 // grey
        when 'R' then 3 // green
        when 'X' then 1 // red
        when 'A' then 0 // grey
        when 'D' then 3 // green
        else 0
        end as Criticality,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      part_price            as PartPrice,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      order_price           as OrderPrice,
      currency_code         as CurrencyCode,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      /* associations */
      _Car,
      _Manuf,
      _Status
      //_Currency
}
