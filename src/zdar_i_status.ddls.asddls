@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Status View'

define view entity ZDAR_I_STATUS
  as select from zdar_status
{
  key status      as Status,
      description as Description
}
