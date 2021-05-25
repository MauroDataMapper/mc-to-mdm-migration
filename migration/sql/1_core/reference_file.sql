INSERT INTO maurodatamapper.core.reference_file(id, version, file_size, date_created, last_updated, multi_facet_aware_item_domain_type, file_type, file_name,
                                                file_contents,multi_facet_aware_item_id, created_by)
SELECT cf.id,
       cf.version,
       cf.file_size,
       cf.date_created,
       cf.last_updated,
       CASE
           WHEN catalogue_item_id IS NOT NULL
               THEN ci.domain_type
           WHEN terminology_id IS NOT NULL
               THEN 'Terminology'
           WHEN code_set_id IS NOT NULL
               THEN 'CodeSet'
           WHEN term_id IS NOT NULL
               THEN 'Term'
       END                                                               AS multi_facet_aware_item_domain_type,
       cf.file_type,
       cf.file_name,
       cf.file_contents,
       coalesce(catalogue_item_id, terminology_id, code_set_id, term_id) AS multi_facet_aware_item_id,
       u.email_address
FROM maurodatamapper.metadatacatalogue.catalogue_file cf
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON cf.created_by_id = u.id
     LEFT JOIN maurodatamapper.metadatacatalogue.catalogue_user pp ON cf.id = pp.profile_picture_id
     LEFT JOIN maurodatamapper.metadatacatalogue.catalogue_item ci ON cf.catalogue_item_id = ci.id
WHERE pp.id IS NULL AND
      catalogue_item_id IS NOT NULL AND
      terminology_id IS NOT NULL AND
      code_set_id IS NOT NULL AND
      term_id IS NOT NULL
-- Do not want to copy user image files