INSERT INTO maurodatamapper.core.breadcrumb_tree(id, version, domain_type, finalised, domain_id, tree_string, top_breadcrumb_tree, label, parent_id)
SELECT uuid_generate_v4()                                                                                   AS id,
       0                                                                                                    AS version,
       domain_type,
       finalised,
       id                                                                                                   AS domain_id,
       concat(id, '|', domain_type, '|', label, '|', CASE finalised WHEN TRUE THEN 'true' ELSE 'false' END) AS tree_string,
       TRUE                                                                                                 AS top_breadcrumb_tree,
       label,
       NULL                                                                                                 AS parent_id
FROM maurodatamapper.metadatacatalogue.terminology;

INSERT INTO maurodatamapper.terminology.terminology(id, version, date_created, finalised, readable_by_authenticated_users, date_finalised,
                                                    documentation_version, readable_by_everyone, model_type, last_updated, organisation, deleted,
                                                    author, breadcrumb_tree_id, folder_id, created_by, aliases_string, label, description,
                                                    authority_id, branch_name, model_version)
SELECT t.id,
       t.version,
       t.date_created,
       t.finalised,
       readable_by_authenticated,
       date_finalised,
       documentation_version,
       readable_by_everyone,
       'Terminology',
       t.last_updated,
       t.organisation,
       deleted,
       author,
       bt.id  AS breadcrumb_tree_id,
       folder_id,
       u.email_address,
       aliases_string,
       t.label,
       description,
       NULL   AS authority_id,
       'main' AS branchName,
       CASE
           WHEN t.finalised = TRUE
               THEN '1.0.0'
       END    AS model_version
FROM maurodatamapper.metadatacatalogue.terminology t
     INNER JOIN maurodatamapper.core.breadcrumb_tree bt ON bt.domain_id = t.id
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON t.created_by_id = u.id;


INSERT INTO maurodatamapper.core.version_link(id, version, date_created, last_updated, catalogue_item_domain_type, target_model_domain_type,
                                              link_type, target_model_id, catalogue_item_id, created_by)
SELECT uuid_generate_v4()              AS id,
       0                               AS version,
       current_timestamp               AS date_created,
       current_timestamp               AS last_updated,
       'Terminology'                   AS catalogue_item_domain_type,
       'Terminology'                   AS target_model_domain_type,
       'SUPERSEDED_BY_DOCUMENTATION'   AS link_type,
       source.superseded_by_id         AS target_model_id,
       source.id                       AS catalogue_item_id,
       'migration@maurodatamapper.com' AS created_by
FROM maurodatamapper.metadatacatalogue.terminology source
WHERE superseded_by_id IS NOT NULL;


INSERT INTO maurodatamapper.terminology.join_terminology_to_facet(terminology_id, classifier_id)
SELECT t.id AS terminology_id,
       classifier_id
FROM maurodatamapper.terminology.terminology t
     INNER JOIN maurodatamapper.metadatacatalogue.join_terminology_to_classifier jt ON jt.terminology_id = t.id;

INSERT INTO maurodatamapper.terminology.join_terminology_to_facet(terminology_id, annotation_id)
SELECT t.id   AS terminology_id,
       ann.id AS annotation_id
FROM maurodatamapper.terminology.terminology t
     INNER JOIN maurodatamapper.core.annotation ann ON ann.catalogue_item_id = t.id AND ann.catalogue_item_domain_type = 'Terminology';


INSERT INTO maurodatamapper.terminology.join_terminology_to_facet(terminology_id, version_link_id)
SELECT t.id  AS terminology_id,
       vl.id AS version_link_id
FROM maurodatamapper.terminology.terminology t
     INNER JOIN maurodatamapper.core.version_link vl ON vl.catalogue_item_id = t.id AND vl.catalogue_item_domain_type = 'Terminology';

INSERT INTO maurodatamapper.terminology.join_terminology_to_facet(terminology_id, reference_file_id)
SELECT t.id  AS terminology_id,
       rf.id AS reference_file_id
FROM maurodatamapper.terminology.terminology t
     INNER JOIN maurodatamapper.core.reference_file rf ON rf.catalogue_item_id = t.id AND rf.catalogue_item_domain_type = 'Terminology';

INSERT INTO maurodatamapper.terminology.join_terminology_to_facet(terminology_id, metadata_id)
SELECT t.id  AS terminology_id,
       md.id AS metadata_id
FROM maurodatamapper.terminology.terminology t
     INNER JOIN maurodatamapper.core.metadata md ON md.catalogue_item_id = t.id AND md.catalogue_item_domain_type = 'Terminology';
