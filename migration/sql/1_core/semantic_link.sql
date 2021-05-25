INSERT INTO maurodatamapper.core.semantic_link(id, version, date_created, target_multi_facet_aware_item_id, last_updated, multi_facet_aware_item_domain_type,
                                               target_multi_facet_aware_item_domain_type, link_type, multi_facet_aware_item_id, created_by)
SELECT sl.id,
       sl.version,
       sl.date_created,
       coalesce(target_catalogue_item_id, target_code_set_id, target_term_id) AS target_multi_facet_aware_item_id,
       sl.last_updated,
       CASE
           WHEN source_catalogue_item_id IS NOT NULL
               THEN sci.domain_type
           WHEN source_code_set_id IS NOT NULL
               THEN 'CodeSet'
           WHEN source_term_id IS NOT NULL
               THEN 'Term'
       END                                                                    AS multi_facet_aware_item_domain_type,
       CASE
           WHEN target_catalogue_item_id IS NOT NULL
               THEN tci.domain_type

           WHEN target_code_set_id IS NOT NULL
               THEN 'CodeSet'
           WHEN target_term_id IS NOT NULL
               THEN 'Term'
       END                                                                    AS target_multi_facet_aware_item_domain_type,
       sl.link_type,
       coalesce(source_catalogue_item_id, source_code_set_id, source_term_id) AS multi_facet_aware_item_id,
       u.email_address
FROM maurodatamapper.metadatacatalogue.semantic_link sl
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON sl.created_by_id = u.id
     LEFT JOIN maurodatamapper.metadatacatalogue.catalogue_item sci ON sl.source_catalogue_item_id = sci.id
     LEFT JOIN maurodatamapper.metadatacatalogue.catalogue_item tci ON sl.target_catalogue_item_id = tci.id
WHERE sl.link_type IN ('REFINES',
                       'DOES_NOT_REFINE')