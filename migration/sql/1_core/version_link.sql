INSERT INTO maurodatamapper.core.version_link(id, version, date_created, last_updated, catalogue_item_domain_type, target_model_domain_type,
                                              link_type, target_model_id, catalogue_item_id, created_by)
SELECT sl.id,
       sl.version,
       sl.date_created,
       sl.last_updated,
       CASE
           WHEN source_catalogue_item_id IS NOT NULL
               THEN 'DataModel'
           WHEN source_code_set_id IS NOT NULL
               THEN 'CodeSet'
       END                                                    AS catalogue_item_domain_type,
       CASE
           WHEN target_catalogue_item_id IS NOT NULL
               THEN 'DataModel'

           WHEN target_code_set_id IS NOT NULL
               THEN 'CodeSet'
       END                                                    AS target_catalogue_item_domain_type,
       CASE

           WHEN sci.label <> tci.label AND sl.link_type = 'NEW_VERSION_OF'
               THEN 'NEW_MODEL_VERSION_OF'
           WHEN sci.label <> tci.label AND sl.link_type = 'SUPERSEDED_BY'
               THEN 'SUPERSEDED_BY_MODEL'
           WHEN sci.label = tci.label AND sl.link_type = 'NEW_VERSION_OF'
               THEN 'NEW_DOCUMENTATION_VERSION_OF'
           WHEN sci.label = tci.label AND sl.link_type = 'SUPERSEDED_BY'
               THEN 'SUPERSEDED_BY_DOCUMENTATION'
       END                                                    AS link_type,
       coalesce(target_catalogue_item_id, target_code_set_id) AS target_model_id,
       coalesce(source_catalogue_item_id, source_code_set_id) AS catalogue_item_id,
       u.email_address
FROM maurodatamapper.metadatacatalogue.semantic_link sl
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON sl.created_by_id = u.id
     LEFT JOIN maurodatamapper.metadatacatalogue.catalogue_item sci ON sl.source_catalogue_item_id = sci.id
     LEFT JOIN maurodatamapper.metadatacatalogue.catalogue_item tci ON sl.target_catalogue_item_id = tci.id
WHERE sl.link_type IN ('SUPERSEDED_BY',
                       'NEW_VERSION_OF');