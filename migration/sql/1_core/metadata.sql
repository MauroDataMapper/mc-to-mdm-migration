INSERT INTO maurodatamapper.core.metadata(id, version, date_created, last_updated, catalogue_item_domain_type, namespace, catalogue_item_id, value,
                                          created_by, key)
SELECT m.id,
       m.version,
       m.date_created,
       m.last_updated,
       CASE
           WHEN catalogue_item_id IS NOT NULL
               THEN ci.domain_type
           WHEN terminology_id IS NOT NULL
               THEN 'Terminology'
           WHEN code_set_id IS NOT NULL
               THEN 'CodeSet'
           WHEN term_id IS NOT NULL
               THEN 'Term'
       END                                                               AS catalogue_item_domain_type,
       m.namespace,
       coalesce(catalogue_item_id, terminology_id, code_set_id, term_id) AS catalogue_item_id,
       m.value,
       u.email_address,
       m.key
FROM maurodatamapper.metadatacatalogue.metadata m
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON m.created_by_id = u.id
     LEFT JOIN maurodatamapper.metadatacatalogue.catalogue_item ci ON m.catalogue_item_id = ci.id
WHERE catalogue_item_id IS NOT NULL OR
      terminology_id IS NOT NULL OR
      code_set_id IS NOT NULL OR
      term_id IS NOT NULL