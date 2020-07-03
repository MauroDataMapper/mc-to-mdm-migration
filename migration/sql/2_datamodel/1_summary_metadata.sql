INSERT INTO maurodatamapper.datamodel.summary_metadata(id, version, summary_metadata_type, date_created, last_updated, catalogue_item_domain_type,
                                                       catalogue_item_id, created_by, label, description)
SELECT sm.id,
       sm.version,
       UPPER(summary_metadata_type),
       sm.date_created,
       sm.last_updated,
       ci.domain_type,
       catalogue_item_id,
       u.email_address,
       name,
       sm.description
FROM maurodatamapper.metadatacatalogue.summary_metadata sm
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_item ci ON ci.id = sm.catalogue_item_id
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON sm.created_by_id = u.id;