INSERT INTO maurodatamapper.core.breadcrumb_tree(id, version, domain_type, finalised, domain_id, tree_string, top_breadcrumb_tree, label, parent_id)
SELECT uuid_generate_v4()                                                                                      AS id,
       0                                                                                                       AS version,
       domain_type,
       finalised,
       dm.id                                                                                                   AS domain_id,
       CONCAT(dm.id, '|', domain_type, '|', label, '|', CASE finalised WHEN TRUE THEN 'true' ELSE 'false' END) AS tree_string,
       TRUE                                                                                                    AS top_breadcrumb_tree,
       label,
       NULL                                                                                                    AS parent_id
FROM maurodatamapper.metadatacatalogue.data_model dm
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_item ci ON ci.id = dm.id;

INSERT INTO maurodatamapper.datamodel.data_model(id, version, date_created, finalised, readable_by_authenticated_users, date_finalised,
                                                 documentation_version, readable_by_everyone, model_type, last_updated, organisation, deleted, author,
                                                 breadcrumb_tree_id, folder_id, created_by, aliases_string, label, description, authority_id,
                                                 branch_name, model_version)
SELECT ci.id,
       ci.version,
       ci.date_created,
       dm.finalised,
       readable_by_authenticated,
       date_finalised,
       documentation_version,
       readable_by_everyone,
       CASE
           WHEN type IN ('DATA_ASSET', 'Data Asset')
               THEN 'Data Asset'
           WHEN type IN ('DATA_STANDARD', 'Data Standard')
               THEN 'Data Standard'
       END       AS model_type,
       ci.last_updated,
       dm.organisation,
       deleted,
       author,
       bt.id     AS breadcrumb_tree_id,
       folder_id,
       u.email_address,
       aliases_string,
       ci.label,
       description,
       (SELECT id
        FROM maurodatamapper.core.authority
        LIMIT 1) AS authority_id,
       'main'    AS branchName,
       CASE
           WHEN dm.finalised = TRUE
               THEN '1.0.0'
       END       AS model_version
FROM maurodatamapper.metadatacatalogue.data_model dm
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_item ci ON ci.id = dm.id
     INNER JOIN maurodatamapper.core.breadcrumb_tree bt ON bt.domain_id = ci.id
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON ci.created_by_id = u.id;

INSERT INTO maurodatamapper.datamodel.join_datamodel_to_facet(datamodel_id, classifier_id)
SELECT dm.id AS datamodel_id,
       classifier_id
FROM maurodatamapper.datamodel.data_model dm
     INNER JOIN maurodatamapper.metadatacatalogue.join_catalogue_item_to_classifier jci ON jci.catalogue_item_id = dm.id;

INSERT INTO maurodatamapper.datamodel.join_datamodel_to_facet(datamodel_id, annotation_id)
SELECT dm.id  AS datamodel_id,
       ann.id AS annotation_id
FROM maurodatamapper.datamodel.data_model dm
     INNER JOIN maurodatamapper.core.annotation ann ON ann.multi_facet_aware_item_id = dm.id AND ann.multi_facet_aware_item_domain_type = 'DataModel';

INSERT INTO maurodatamapper.datamodel.join_datamodel_to_facet(datamodel_id, semantic_link_id)
SELECT dm.id AS datamodel_id,
       sl.id AS semantic_link_id
FROM maurodatamapper.datamodel.data_model dm
     INNER JOIN maurodatamapper.core.semantic_link sl ON sl.multi_facet_aware_item_id = dm.id AND sl.multi_facet_aware_item_domain_type = 'DataModel';

INSERT INTO maurodatamapper.datamodel.join_datamodel_to_facet(datamodel_id, version_link_id)
SELECT dm.id AS datamodel_id,
       vl.id AS version_link_id
FROM maurodatamapper.datamodel.data_model dm
     INNER JOIN maurodatamapper.core.version_link vl ON vl.multi_facet_aware_item_id = dm.id AND vl.multi_facet_aware_item_domain_type = 'DataModel';

INSERT INTO maurodatamapper.datamodel.join_datamodel_to_facet(datamodel_id, reference_file_id)
SELECT dm.id AS datamodel_id,
       rf.id AS reference_file_id
FROM maurodatamapper.datamodel.data_model dm
     INNER JOIN maurodatamapper.core.reference_file rf ON rf.multi_facet_aware_item_id = dm.id AND rf.multi_facet_aware_item_domain_type = 'DataModel';

INSERT INTO maurodatamapper.datamodel.join_datamodel_to_facet(datamodel_id, metadata_id)
SELECT dm.id AS datamodel_id,
       md.id AS metadata_id
FROM maurodatamapper.datamodel.data_model dm
     INNER JOIN maurodatamapper.core.metadata md ON md.multi_facet_aware_item_id = dm.id AND md.multi_facet_aware_item_domain_type = 'DataModel';

INSERT INTO maurodatamapper.datamodel.join_datamodel_to_facet(datamodel_id, summary_metadata_id)
SELECT dm.id AS datamodel_id,
       sm.id AS summary_metadata_id
FROM maurodatamapper.datamodel.data_model dm
     INNER JOIN maurodatamapper.datamodel.summary_metadata sm ON sm.multi_facet_aware_item_id = dm.id AND sm.multi_facet_aware_item_domain_type = 'DataModel';
