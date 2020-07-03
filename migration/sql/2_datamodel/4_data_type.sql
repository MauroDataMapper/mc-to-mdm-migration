INSERT INTO maurodatamapper.core.breadcrumb_tree(id, version, domain_type, finalised, domain_id, tree_string, top_breadcrumb_tree, label, parent_id)
SELECT uuid_generate_v4()                                                                     AS id,
       0                                                                                      AS version,
       ci.domain_type,
       NULL                                                                                   AS finalised,
       dt.id                                                                                  AS domain_id,
       concat(pbt.tree_string, E'\n', dt.id, '|', ci.domain_type, '|', ci.label, '|', 'null') AS tree_string,
       FALSE                                                                                  AS top_breadcrumb_tree,
       ci.label,
       pbt.id                                                                                 AS parent_id
FROM maurodatamapper.metadatacatalogue.data_type dt
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_item ci ON ci.id = dt.id
     INNER JOIN maurodatamapper.core.breadcrumb_tree pbt ON pbt.domain_id = dt.data_model_id;

INSERT INTO maurodatamapper.datamodel.data_type(id, version, date_created, domain_type, last_updated, path, depth, breadcrumb_tree_id, data_model_id,
                                                idx, created_by, aliases_string, label, description, class, units, reference_class_id)
SELECT ci.id,
       ci.version,
       ci.date_created,
       dt.type,
       ci.last_updated,
       path,
       depth - 1  AS depth,
       bt.id      AS breadcrumb_tree_id,
       data_model_id,
       2147483647 AS idx,
       u.email_address,
       aliases_string,
       ci.label,
       description,
       CASE
           WHEN pt.id IS NOT NULL
               THEN 'uk.ac.ox.softeng.maurodatamapper.datamodel.item.datatype.PrimitiveType'
           WHEN rt.id IS NOT NULL
               THEN 'uk.ac.ox.softeng.maurodatamapper.datamodel.item.datatype.ReferenceType'
           WHEN et.id IS NOT NULL
               THEN 'uk.ac.ox.softeng.maurodatamapper.datamodel.item.datatype.EnumerationType'
       END        AS class,
       units,
       reference_class_id
FROM maurodatamapper.metadatacatalogue.data_type dt
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_item ci ON ci.id = dt.id
     INNER JOIN maurodatamapper.core.breadcrumb_tree bt ON bt.domain_id = ci.id
     LEFT JOIN maurodatamapper.metadatacatalogue.primitive_type pt ON pt.id = dt.id
     LEFT JOIN maurodatamapper.metadatacatalogue.reference_type rt ON rt.id = dt.id
     LEFT JOIN maurodatamapper.metadatacatalogue.enumeration_type et ON et.id = dt.id
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON ci.created_by_id = u.id;

INSERT INTO maurodatamapper.datamodel.join_datatype_to_facet(datatype_id, classifier_id, annotation_id, semantic_link_id, reference_file_id,
                                                             metadata_id, summary_metadata_id)
SELECT dt.id AS datatype_id,
       classifier_id,
       NULL  AS annotation_id,
       NULL  AS semantic_link_id,
       NULL  AS reference_file_id,
       NULL  AS metadata_id,
       NULL  AS summary_metadata_id
FROM maurodatamapper.datamodel.data_type dt
     INNER JOIN maurodatamapper.metadatacatalogue.join_catalogue_item_to_classifier jci ON jci.catalogue_item_id = dt.id;

INSERT INTO maurodatamapper.datamodel.join_datatype_to_facet(datatype_id, classifier_id, annotation_id, semantic_link_id, reference_file_id,
                                                             metadata_id, summary_metadata_id)
SELECT dt.id  AS datatype_id,
       NULL   AS classifier_id,
       ann.id AS annotation_id,
       NULL   AS semantic_link_id,
       NULL   AS reference_file_id,
       NULL   AS metadata_id,
       NULL   AS summary_metadata_id
FROM maurodatamapper.datamodel.data_type dt
     INNER JOIN maurodatamapper.core.annotation ann ON ann.catalogue_item_id = dt.id AND ann.catalogue_item_domain_type = dt.domain_type;

INSERT INTO maurodatamapper.datamodel.join_datatype_to_facet(datatype_id, classifier_id, annotation_id, semantic_link_id, reference_file_id,
                                                             metadata_id, summary_metadata_id)
SELECT dt.id AS datatype_id,
       NULL  AS classifier_id,
       NULL  AS annotation_id,
       sl.id AS semantic_link_id,
       NULL  AS reference_file_id,
       NULL  AS metadata_id,
       NULL  AS summary_metadata_id
FROM maurodatamapper.datamodel.data_type dt
     INNER JOIN maurodatamapper.core.semantic_link sl ON sl.catalogue_item_id = dt.id AND sl.catalogue_item_domain_type = dt.domain_type;

INSERT INTO maurodatamapper.datamodel.join_datatype_to_facet(datatype_id, classifier_id, annotation_id, semantic_link_id, reference_file_id,
                                                             metadata_id, summary_metadata_id)
SELECT dt.id AS datatype_id,
       NULL  AS classifier_id,
       NULL  AS annotation_id,
       NULL  AS semantic_link_id,
       rf.id AS reference_file_id,
       NULL  AS metadata_id,
       NULL  AS summary_metadata_id
FROM maurodatamapper.datamodel.data_type dt
     INNER JOIN maurodatamapper.core.reference_file rf ON rf.catalogue_item_id = dt.id AND rf.catalogue_item_domain_type = dt.domain_type;

INSERT INTO maurodatamapper.datamodel.join_datatype_to_facet(datatype_id, classifier_id, annotation_id, semantic_link_id, reference_file_id,
                                                             metadata_id, summary_metadata_id)
SELECT dt.id AS datatype_id,
       NULL  AS classifier_id,
       NULL  AS annotation_id,
       NULL  AS semantic_link_id,
       NULL  AS reference_file_id,
       md.id AS metadata_id,
       NULL  AS summary_metadata_id
FROM maurodatamapper.datamodel.data_type dt
     INNER JOIN maurodatamapper.core.metadata md ON md.catalogue_item_id = dt.id AND md.catalogue_item_domain_type = dt.domain_type;

INSERT INTO maurodatamapper.datamodel.join_datatype_to_facet(datatype_id, classifier_id, annotation_id, semantic_link_id, reference_file_id,
                                                             metadata_id, summary_metadata_id)
SELECT dt.id AS datatype_id,
       NULL  AS classifier_id,
       NULL  AS annotation_id,
       NULL  AS semantic_link_id,
       NULL  AS reference_file_id,
       NULL  AS metadata_id,
       sm.id AS summary_metadata_id
FROM maurodatamapper.datamodel.data_type dt
     INNER JOIN maurodatamapper.datamodel.summary_metadata sm ON sm.catalogue_item_id = dt.id AND sm.catalogue_item_domain_type = dt.domain_type;
