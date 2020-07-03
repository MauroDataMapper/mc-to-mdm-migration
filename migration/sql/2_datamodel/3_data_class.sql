/* Procedure to build the breadcrumb tree hierarchy
  This will create the top level BT then loop through all the remaining DCs creating each BT as long as the parent BT exists
 */
CREATE OR REPLACE PROCEDURE datamodel.buildBreadcrumbTree()
AS
$$
DECLARE
    counter INTEGER := 0 ;
BEGIN

    --- Top level DataClasses
    INSERT INTO maurodatamapper.core.breadcrumb_tree(id, version, domain_type, finalised, domain_id, tree_string, top_breadcrumb_tree, label,
                                                     parent_id)
    SELECT uuid_generate_v4()                                                                      AS id,
           0                                                                                       AS version,
           ci.domain_type,
           NULL                                                                                    AS finalised,
           dc.id                                                                                   AS domain_id,
           concat(dmbt.tree_string, E'\n', dc.id, '|', ci.domain_type, '|', ci.label, '|', 'null') AS tree_string,
           FALSE                                                                                   AS top_breadcrumb_tree,
           ci.label,
           dmbt.id                                                                                 AS parent_id
    FROM maurodatamapper.metadatacatalogue.data_class dc
         INNER JOIN maurodatamapper.metadatacatalogue.catalogue_item ci ON ci.id = dc.id
         INNER JOIN maurodatamapper.core.breadcrumb_tree dmbt ON dmbt.domain_id = dc.data_model_id
    WHERE parent_data_class_id IS NULL;

    counter := (SELECT count(*)
                FROM maurodatamapper.metadatacatalogue.data_class dc
                     LEFT JOIN maurodatamapper.core.breadcrumb_tree bt ON dc.id = bt.domain_id
                WHERE bt.id IS NULL);
    RAISE NOTICE 'Loaded top level DataClasses';

    RAISE NOTICE 'DataClasses left to load %', counter;
    IF (counter = 0)
    THEN
        RETURN;
    END IF;

    WHILE counter <> 0
        LOOP
            INSERT INTO maurodatamapper.core.breadcrumb_tree(id, version, domain_type, finalised, domain_id, tree_string, top_breadcrumb_tree,
                                                             label,
                                                             parent_id)
            SELECT uuid_generate_v4() AS id,
                   0                  AS version,
                   ci.domain_type,
                   NULL               AS finalised,
                   dc.id              AS domain_id,
                   concat(pcbt.tree_string, E'\n', dc.id, '|', ci.domain_type, '|', ci.label, '|', 'null')
                                      AS tree_string,
                   FALSE              AS top_breadcrumb_tree,
                   ci.label,
                   pcbt.id            AS parent_id
            FROM maurodatamapper.metadatacatalogue.data_class dc
                 INNER JOIN maurodatamapper.metadatacatalogue.catalogue_item ci ON ci.id = dc.id
                 LEFT JOIN maurodatamapper.core.breadcrumb_tree pcbt ON pcbt.domain_id = dc.parent_data_class_id
                 LEFT JOIN maurodatamapper.core.breadcrumb_tree bt ON dc.id = bt.domain_id
            WHERE parent_data_class_id IS NOT NULL AND
                  pcbt.id IS NOT NULL AND
                  bt.id IS NULL;

            counter := (SELECT count(*)
                        FROM maurodatamapper.metadatacatalogue.data_class dc
                             LEFT JOIN maurodatamapper.core.breadcrumb_tree bt ON dc.id = bt.domain_id
                        WHERE bt.id IS NULL);
            RAISE NOTICE 'DataClasses left to load %', counter;

        END LOOP;

    RETURN;
END;
$$ LANGUAGE plpgsql;

-- Actually build the BTs
CALL datamodel.buildBreadcrumbTree();

-- Clean up by removing the procedure
DROP PROCEDURE datamodel.buildBreadcrumbTree();

INSERT INTO maurodatamapper.datamodel.data_class(id, version, date_created, last_updated, path, depth, min_multiplicity, max_multiplicity,
                                                 parent_data_class_id, breadcrumb_tree_id, data_model_id, idx, created_by, aliases_string, label,
                                                 description)
SELECT ci.id,
       ci.version,
       ci.date_created,
       ci.last_updated,
       path,
       depth - 1  AS depth,
       min_multiplicity,
       max_multiplicity,
       parent_data_class_id,
       bt.id      AS breadcrumb_tree_id,
       data_model_id,
       2147483647 AS idx,
       u.email_address,
       aliases_string,
       ci.label,
       description
FROM maurodatamapper.metadatacatalogue.data_class dc
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_item ci ON ci.id = dc.id
     INNER JOIN maurodatamapper.core.breadcrumb_tree bt ON bt.domain_id = ci.id
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON ci.created_by_id = u.id;

INSERT INTO maurodatamapper.datamodel.join_dataclass_to_facet(dataclass_id, classifier_id, annotation_id, semantic_link_id, reference_file_id,
                                                              metadata_id, summary_metadata_id)
SELECT dc.id AS dataclass_id,
       classifier_id,
       NULL  AS annotation_id,
       NULL  AS semantic_link_id,
       NULL  AS reference_file_id,
       NULL  AS metadata_id,
       NULL  AS summary_metadata_id
FROM maurodatamapper.datamodel.data_class dc
     INNER JOIN maurodatamapper.metadatacatalogue.join_catalogue_item_to_classifier jci ON jci.catalogue_item_id = dc.id;

INSERT INTO maurodatamapper.datamodel.join_dataclass_to_facet(dataclass_id, classifier_id, annotation_id, semantic_link_id, reference_file_id,
                                                              metadata_id, summary_metadata_id)
SELECT dc.id  AS dataclass_id,
       NULL   AS classifier_id,
       ann.id AS annotation_id,
       NULL   AS semantic_link_id,
       NULL   AS reference_file_id,
       NULL   AS metadata_id,
       NULL   AS summary_metadata_id
FROM maurodatamapper.datamodel.data_class dc
     INNER JOIN maurodatamapper.core.annotation ann ON ann.catalogue_item_id = dc.id AND ann.catalogue_item_domain_type = 'DataClass';

INSERT INTO maurodatamapper.datamodel.join_dataclass_to_facet(dataclass_id, classifier_id, annotation_id, semantic_link_id, reference_file_id,
                                                              metadata_id, summary_metadata_id)
SELECT dc.id AS dataclass_id,
       NULL  AS classifier_id,
       NULL  AS annotation_id,
       sl.id AS semantic_link_id,
       NULL  AS reference_file_id,
       NULL  AS metadata_id,
       NULL  AS summary_metadata_id
FROM maurodatamapper.datamodel.data_class dc
     INNER JOIN maurodatamapper.core.semantic_link sl ON sl.catalogue_item_id = dc.id AND sl.catalogue_item_domain_type = 'DataClass'

INSERT INTO maurodatamapper.datamodel.join_dataclass_to_facet(dataclass_id, classifier_id, annotation_id, semantic_link_id, reference_file_id,
                                                              metadata_id, summary_metadata_id)
SELECT dc.id AS dataclass_id,
       NULL  AS classifier_id,
       NULL  AS annotation_id,
       NULL  AS semantic_link_id,
       rf.id AS reference_file_id,
       NULL  AS metadata_id,
       NULL  AS summary_metadata_id
FROM maurodatamapper.datamodel.data_class dc
     INNER JOIN maurodatamapper.core.reference_file rf ON rf.catalogue_item_id = dc.id AND rf.catalogue_item_domain_type = 'DataClass';

INSERT INTO maurodatamapper.datamodel.join_dataclass_to_facet(dataclass_id, classifier_id, annotation_id, semantic_link_id, reference_file_id,
                                                              metadata_id, summary_metadata_id)
SELECT dc.id AS dataclass_id,
       NULL  AS classifier_id,
       NULL  AS annotation_id,
       NULL  AS semantic_link_id,
       NULL  AS reference_file_id,
       md.id AS metadata_id,
       NULL  AS summary_metadata_id
FROM maurodatamapper.datamodel.data_class dc
     INNER JOIN maurodatamapper.core.metadata md ON md.catalogue_item_id = dc.id AND md.catalogue_item_domain_type = 'DataClass';

INSERT INTO maurodatamapper.datamodel.join_dataclass_to_facet(dataclass_id, classifier_id, annotation_id, semantic_link_id, reference_file_id,
                                                              metadata_id, summary_metadata_id)
SELECT dc.id AS dataclass_id,
       NULL  AS classifier_id,
       NULL  AS annotation_id,
       NULL  AS semantic_link_id,
       NULL  AS reference_file_id,
       NULL  AS metadata_id,
       sm.id AS summary_metadata_id
FROM maurodatamapper.datamodel.data_class dc
     INNER JOIN maurodatamapper.datamodel.summary_metadata sm ON sm.catalogue_item_id = dc.id AND sm.catalogue_item_domain_type = 'DataClass';