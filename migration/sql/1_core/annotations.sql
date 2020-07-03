INSERT INTO maurodatamapper.core.annotation(id, version, date_created, last_updated, path, catalogue_item_domain_type, depth, catalogue_item_id,
                                            parent_annotation_id, created_by, label, description, child_annotations_idx)
SELECT ann.id,
       ann.version,
       ann.date_created,
       ann.last_updated,
       ann.path,
       CASE
           WHEN annotated_component_id IS NOT NULL
               THEN ci.domain_type
           WHEN annotated_terminology_id IS NOT NULL
               THEN 'Terminology'
           WHEN annotated_code_set_id IS NOT NULL
               THEN 'CodeSet'
           WHEN annotated_term_id IS NOT NULL
               THEN 'Term'
       END                                                                                                  AS catalogue_item_domain_type,
       ann.depth - 1                                                                                        AS depth,
       coalesce(annotated_component_id, annotated_terminology_id, annotated_code_set_id, annotated_term_id) AS catalogue_item_id,
       ann.parent_annotation_id,
       u.email_address                                                                                      AS created_by,
       ann.label,
       ann.description,
       ann.child_annotations_idx
FROM maurodatamapper.metadatacatalogue.annotation ann
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON ann.created_by_id = u.id
     LEFT JOIN maurodatamapper.metadatacatalogue.catalogue_item ci ON ann.annotated_component_id = ci.id