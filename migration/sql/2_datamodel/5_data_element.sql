INSERT INTO maurodatamapper.core.breadcrumb_tree(id, version, domain_type, finalised, domain_id, tree_string, top_breadcrumb_tree, label, parent_id)
SELECT uuid_generate_v4()                                                                     AS id,
       0                                                                                      AS version,
       ci.domain_type,
       NULL                                                                                   AS finalised,
       de.id                                                                                  AS domain_id,
       concat(pbt.tree_string, E'\n', de.id, '|', ci.domain_type, '|', ci.label, '|', 'null') AS tree_string,
       FALSE                                                                                  AS top_breadcrumb_tree,
       ci.label,
       pbt.id                                                                                 AS parent_id
FROM maurodatamapper.metadatacatalogue.data_element de
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_item ci ON ci.id = de.id
     INNER JOIN maurodatamapper.core.breadcrumb_tree pbt ON pbt.domain_id = de.data_class_id;


INSERT INTO maurodatamapper.datamodel.data_element(id, version, date_created, data_class_id, last_updated, path, depth, min_multiplicity,
                                                   max_multiplicity, breadcrumb_tree_id, data_type_id, idx, created_by, aliases_string, label,
                                                   description)
SELECT ci.id,
       ci.version,
       ci.date_created,
       data_class_id,
       ci.last_updated,
       path,
       depth - 1  AS depth,
       min_multiplicity,
       max_multiplicity,
       bt.id      AS breadcrumb_tree_id,
       data_type_id,
       2147483647 AS idx,
       u.email_address,
       aliases_string,
       ci.label,
       description
FROM maurodatamapper.metadatacatalogue.data_element de
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_item ci ON ci.id = de.id
     INNER JOIN maurodatamapper.core.breadcrumb_tree bt ON bt.domain_id = ci.id
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON ci.created_by_id = u.id;

INSERT INTO maurodatamapper.datamodel.join_dataelement_to_facet(dataelement_id, classifier_id, annotation_id, semantic_link_id, reference_file_id,
                                                                metadata_id, summary_metadata_id)
SELECT de.id AS dataelement_id,
       classifier_id,
       NULL  AS annotation_id,
       NULL  AS semantic_link_id,
       NULL  AS reference_file_id,
       NULL  AS metadata_id,
       NULL  AS summary_metadata_id
FROM maurodatamapper.datamodel.data_element de
     INNER JOIN maurodatamapper.metadatacatalogue.join_catalogue_item_to_classifier jci ON jci.catalogue_item_id = de.id;

INSERT INTO maurodatamapper.datamodel.join_dataelement_to_facet(dataelement_id, classifier_id, annotation_id, semantic_link_id, reference_file_id,
                                                                metadata_id, summary_metadata_id)
SELECT de.id  AS dataelement_id,
       NULL   AS classifier_id,
       ann.id AS annotation_id,
       NULL   AS semantic_link_id,
       NULL   AS reference_file_id,
       NULL   AS metadata_id,
       NULL   AS summary_metadata_id
FROM maurodatamapper.datamodel.data_element de
     INNER JOIN maurodatamapper.core.annotation ann ON ann.catalogue_item_id = de.id AND ann.catalogue_item_domain_type = 'DataElement';

INSERT INTO maurodatamapper.datamodel.join_dataelement_to_facet(dataelement_id, classifier_id, annotation_id, semantic_link_id, reference_file_id,
                                                                metadata_id, summary_metadata_id)
SELECT de.id AS dataelement_id,
       NULL  AS classifier_id,
       NULL  AS annotation_id,
       sl.id AS semantic_link_id,
       NULL  AS reference_file_id,
       NULL  AS metadata_id,
       NULL  AS summary_metadata_id
FROM maurodatamapper.datamodel.data_element de
     INNER JOIN maurodatamapper.core.semantic_link sl ON sl.catalogue_item_id = de.id AND sl.catalogue_item_domain_type = 'DataElement';

INSERT INTO maurodatamapper.datamodel.join_dataelement_to_facet(dataelement_id, classifier_id, annotation_id, semantic_link_id, reference_file_id,
                                                                metadata_id, summary_metadata_id)
SELECT de.id AS dataelement_id,
       NULL  AS classifier_id,
       NULL  AS annotation_id,
       NULL  AS semantic_link_id,
       rf.id AS reference_file_id,
       NULL  AS metadata_id,
       NULL  AS summary_metadata_id
FROM maurodatamapper.datamodel.data_element de
     INNER JOIN maurodatamapper.core.reference_file rf ON rf.catalogue_item_id = de.id AND rf.catalogue_item_domain_type = 'DataElement';

INSERT INTO maurodatamapper.datamodel.join_dataelement_to_facet(dataelement_id, classifier_id, annotation_id, semantic_link_id, reference_file_id,
                                                                metadata_id, summary_metadata_id)
SELECT de.id AS dataelement_id,
       NULL  AS classifier_id,
       NULL  AS annotation_id,
       NULL  AS semantic_link_id,
       NULL  AS reference_file_id,
       md.id AS metadata_id,
       NULL  AS summary_metadata_id
FROM maurodatamapper.datamodel.data_element de
     INNER JOIN maurodatamapper.core.metadata md ON md.catalogue_item_id = de.id AND md.catalogue_item_domain_type = 'DataElement';

INSERT INTO maurodatamapper.datamodel.join_dataelement_to_facet(dataelement_id, classifier_id, annotation_id, semantic_link_id, reference_file_id,
                                                                metadata_id, summary_metadata_id)
SELECT de.id AS dataelement_id,
       NULL  AS classifier_id,
       NULL  AS annotation_id,
       NULL  AS semantic_link_id,
       NULL  AS reference_file_id,
       NULL  AS metadata_id,
       sm.id AS summary_metadata_id
FROM maurodatamapper.datamodel.data_element de
     INNER JOIN maurodatamapper.datamodel.summary_metadata sm ON sm.catalogue_item_id = de.id AND sm.catalogue_item_domain_type = 'DataElement';
