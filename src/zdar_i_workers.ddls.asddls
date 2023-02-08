@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Workers View - CDS Data Model'
@Search.searchable: true

define view entity ZDAR_I_WORKERS
  as select from zdar_workers as Workers
  association        to parent ZDAR_I_CARS as _Car    on $projection.CarUuid = _Car.Caruuid
{
      @ObjectModel.text.element: ['Surname']
  key worker_id             as WorkerId,
      car_uuid              as CarUuid,
      @Search.defaultSearchElement: true
      @Semantics.name.givenName: true
      name                  as Name,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Semantics.name.familyName: true
      @Semantics.text: true
      surname               as Surname,
      @Semantics.name.jobTitle: true
      jobtitle              as JobTitle,
      @Semantics.telephone.type: [#WORK]
      phone                 as Phone,
      @Semantics.address.zipCode: true
      post                  as Post,
      @Semantics.eMail.address: true
      email                 as EMail,
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
      _Car
}
