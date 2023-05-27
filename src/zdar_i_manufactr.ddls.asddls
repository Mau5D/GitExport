@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Manufacture View - CDS Data Model'
@Search.searchable: true

define view entity ZDAR_I_MANUFACTR
  as select from zdar_manufactr as Manuf
  //association [0..1] to I_Country as _Country on $projection.CountryCode = _Country.Country
{
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['ManufName']
      @EndUserText.label         : 'ID'
  key manufacturer_id   as ManufacturerId,
      @Search.defaultSearchElement: true
      @Semantics.text: true
      @Semantics.organization.name: true
      @EndUserText.label         : 'Name'
      manufacturer_name as ManufName,
      @Semantics.address.street: true
      @EndUserText.label         : 'Street'
      supported_brand   as SuppBrand,
      @EndUserText.label         : 'Part Name'
      part_name         as PartName,
      @EndUserText.label         : 'Amount'
      amount            as Amount,
      @EndUserText.label         : 'Price'
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price             as Price,
      @EndUserText.label         : 'Currency Code'
      currency_code     as CurrencyCode

      /* Associations */

}
