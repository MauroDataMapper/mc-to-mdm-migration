INSERT INTO maurodatamapper.core.breadcrumb_tree(id, version, domain_type, finalised, domain_id, tree_string, top_breadcrumb_tree, label, parent_id)
SELECT uuid_generate_v4()                                                                     AS id,
       0                                                                                      AS version,
       ci.domain_type,
       NULL                                                                                   AS finalised,
       ev.id                                                                                  AS domain_id,
       concat(pbt.tree_string, E'\n', ev.id, '|', ci.domain_type, '|', ci.label, '|', 'null') AS tree_string,
       FALSE                                                                                  AS top_breadcrumb_tree,
       ci.label,
       pbt.id                                                                                 AS parent_id
FROM maurodatamapper.metadatacatalogue.enumeration_value ev
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_item ci ON ci.id = ev.id
     INNER JOIN maurodatamapper.core.breadcrumb_tree pbt ON pbt.domain_id = ev.enumeration_type_id;

INSERT INTO maurodatamapper.datamodel.enumeration_value(id, version, date_created, enumeration_type_id, value, last_updated, path, depth,
                                                        breadcrumb_tree_id, idx, category, created_by, aliases_string, key, label, description)
SELECT ci.id,
       ci.version,
       ci.date_created,
       enumeration_type_id,
       value,
       ci.last_updated,
       path,
       depth - 1  AS depth,
       bt.id      AS breadcrumb_tree_id,
       2147483647 AS idx,
       category,
       u.email_address,
       aliases_string,
       key,
       ci.label,
       description
FROM maurodatamapper.metadatacatalogue.enumeration_value ev
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_item ci ON ci.id = ev.id
     INNER JOIN maurodatamapper.core.breadcrumb_tree bt ON bt.domain_id = ci.id
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON ci.created_by_id = u.id;

INSERT INTO maurodatamapper.datamodel.join_enumerationvalue_to_facet(enumerationvalue_id, classifier_id, annotation_id, semantic_link_id,
                                                                     reference_file_id,
                                                                     metadata_id)
SELECT ev.id AS enumerationvalue_id,
       classifier_id,
       NULL  AS annotation_id,
       NULL  AS semantic_link_id,
       NULL  AS reference_file_id,
       NULL  AS metadata_id
FROM maurodatamapper.datamodel.enumeration_value ev
     INNER JOIN maurodatamapper.metadatacatalogue.join_catalogue_item_to_classifier jci ON jci.catalogue_item_id = ev.id;

INSERT INTO maurodatamapper.datamodel.join_enumerationvalue_to_facet(enumerationvalue_id, classifier_id, annotation_id, semantic_link_id,
                                                                     reference_file_id,
                                                                     metadata_id)
SELECT ev.id  AS enumerationvalue_id,
       NULL   AS classifier_id,
       ann.id AS annotation_id,
       NULL   AS semantic_link_id,
       NULL   AS reference_file_id,
       NULL   AS metadata_id
FROM maurodatamapper.datamodel.enumeration_value ev
     INNER JOIN maurodatamapper.core.annotation ann ON ann.multi_facet_aware_item_id = ev.id AND ann.multi_facet_aware_item_domain_type = 'EnumerationValue';

INSERT INTO maurodatamapper.datamodel.join_enumerationvalue_to_facet(enumerationvalue_id, classifier_id, annotation_id, semantic_link_id,
                                                                     reference_file_id,
                                                                     metadata_id)
SELECT ev.id AS enumerationvalue_id,
       NULL  AS classifier_id,
       NULL  AS annotation_id,
       sl.id AS semantic_link_id,
       NULL  AS reference_file_id,
       NULL  AS metadata_id
FROM maurodatamapper.datamodel.enumeration_value ev
     INNER JOIN maurodatamapper.core.semantic_link sl ON sl.multi_facet_aware_item_id = ev.id AND sl.multi_facet_aware_item_domain_type = 'EnumerationValue';

INSERT INTO maurodatamapper.datamodel.join_enumerationvalue_to_facet(enumerationvalue_id, classifier_id, annotation_id, semantic_link_id,
                                                                     reference_file_id,
                                                                     metadata_id)
SELECT ev.id AS enumerationvalue_id,
       NULL  AS classifier_id,
       NULL  AS annotation_id,
       NULL  AS semantic_link_id,
       rf.id AS reference_file_id,
       NULL  AS metadata_id
FROM maurodatamapper.datamodel.enumeration_value ev
     INNER JOIN maurodatamapper.core.reference_file rf ON rf.multi_facet_aware_item_id = ev.id AND rf.multi_facet_aware_item_domain_type = 'EnumerationValue';

INSERT INTO maurodatamapper.datamodel.join_enumerationvalue_to_facet(enumerationvalue_id, classifier_id, annotation_id, semantic_link_id,
                                                                     reference_file_id,
                                                                     metadata_id)
SELECT ev.id AS enumerationvalue_id,
       NULL  AS classifier_id,
       NULL  AS annotation_id,
       NULL  AS semantic_link_id,
       NULL  AS reference_file_id,
       md.id AS metadata_id
FROM maurodatamapper.datamodel.enumeration_value ev
     INNER JOIN maurodatamapper.core.metadata md ON md.multi_facet_aware_item_id = ev.id AND md.multi_facet_aware_item_domain_type = 'EnumerationValue'
