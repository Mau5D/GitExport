@EndUserText.label: 'Projection Components Log View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true

define view entity ZDAR_C_COMPLOG as projection on ZDAR_I_COMPLOG
{
    key LogUuid,
    @Search.defaultSearchElement: true
    CarUuid,
    @Search.defaultSearchElement: true
    CarpartUuid,
    Status,
    Message,
    
    /* Associations */
    _Car : redirected to parent ZDAR_C_CARS
}
