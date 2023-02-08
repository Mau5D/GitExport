@EndUserText.label: 'Projection Workers View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true

define view entity ZDAR_C_WORKERS
  as projection on ZDAR_I_WORKERS
{
      @Search.defaultSearchElement: true
  key WorkerId,
      CarUuid,
      @Search.defaultSearchElement: true
      Name,
      Surname,
      JobTitle,
      Phone,
      Post,
      EMail,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      /* Associations */
      _Car : redirected to parent ZDAR_C_CARS
}
