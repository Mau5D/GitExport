@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Manufacture View - CDS Data Model'
@Search.searchable: true

define view entity ZDAR_I_MANUFACTR
  as select from zdar_manufactr as Manuf
  //association [0..1] to I_Country as _Country on $projection.CountryCode = _Country.Country
{
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['Name']
      @EndUserText.label         : 'ID'
  key manufacturer_id       as ManufacturerId,
      @Search.defaultSearchElement: true
      @Semantics.text: true
      @Semantics.organization.name: true
      @EndUserText.label         : 'Name'
      name                  as Name,
      @Semantics.address.street: true
      @EndUserText.label         : 'Street'
      street                as Street,
      @Semantics.address.zipCode: true
      @EndUserText.label         : 'Postal Code'
      postal_code           as PostalCode,
      @Search.defaultSearchElement: true
      @Semantics.address.city: true
      @EndUserText.label         : 'City'
      city                  as City,
      @Consumption.valueHelpDefinition: [{entity: { name: 'I_Country', element: 'Country' } }]
      @Semantics.address.country: true
      @EndUserText.label         : 'Country Code'
      country_code          as CountryCode,
      @EndUserText.label         : 'Phone Number'
      @Semantics.telephone.type: [#WORK]
      phone_number          as PhoneNumber,
      @EndUserText.label         : 'Email Address'
      @Semantics.eMail.address: true
      email_address         as EmailAddress,
      @EndUserText.label         : 'Part Name'
      part_name             as PartName,
      @EndUserText.label         : 'Price'
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price                 as Price,
      @EndUserText.label         : 'Currency Code'
      currency_code         as CurrencyCode,
      @Semantics.user.createdBy: true
      @EndUserText.label         : 'Created By'
      created_by            as CreatedBy,
      @Semantics.user.lastChangedBy: true
      @EndUserText.label         : 'Last Changed By'
      last_changed_by       as LastChangedBy,
      @EndUserText.label         : 'Local Last Changed At'
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt

      /* Associations */


}
