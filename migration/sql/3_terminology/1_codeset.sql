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
FROM maurodatamapper.metadatacatalogue.code_set;

INSERT INTO maurodatamapper.terminology.code_set(id, version, date_created, finalised, readable_by_authenticated_users, date_finalised,
                                                 documentation_version, readable_by_everyone, model_type, last_updated, organisation, deleted,
                                                 author, breadcrumb_tree_id, folder_id, created_by, aliases_string, label, description,
                                                 authority_id, branch_name, model_version)
SELECT cs.id,
       cs.version,
       cs.date_created,
       cs.finalised,
       readable_by_authenticated,
       date_finalised,
       documentation_version,
       readable_by_everyone,
       'CodeSet',
       cs.last_updated,
       cs.organisation,
       deleted,
       author,
       bt.id  AS breadcrumb_tree_id,
       folder_id,
       u.email_address,
       aliases_string,
       cs.label,
       description,
       (select id from maurodatamapper.core.authority limit 1)   AS authority_id,
       'main' AS branchName,
       CASE
           WHEN cs.finalised = TRUE
               THEN '1.0.0'
       END    AS model_version
FROM maurodatamapper.metadatacatalogue.code_set cs
     INNER JOIN maurodatamapper.core.breadcrumb_tree bt ON bt.domain_id = cs.id
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON cs.created_by_id = u.id;

INSERT INTO maurodatamapper.terminology.join_codeset_to_facet(codeset_id, classifier_id)
SELECT cs.id AS code_set_id,
       classifier_id
FROM maurodatamapper.terminology.code_set cs
     INNER JOIN maurodatamapper.metadatacatalogue.join_code_set_to_classifier jt ON jt.code_set_id = cs.id;

INSERT INTO maurodatamapper.terminology.join_codeset_to_facet(codeset_id, annotation_id)
SELECT cs.id  AS code_set_id,
       ann.id AS annotation_id
FROM maurodatamapper.terminology.code_set cs
     INNER JOIN maurodatamapper.core.annotation ann ON ann.multi_facet_aware_item_id = cs.id AND ann.multi_facet_aware_item_domain_type = 'CodeSet';

INSERT INTO maurodatamapper.terminology.join_codeset_to_facet(codeset_id, semantic_link_id)
SELECT cs.id AS code_set_id,
       sl.id AS semantic_link_id
FROM maurodatamapper.terminology.code_set cs
     INNER JOIN maurodatamapper.core.semantic_link sl ON sl.multi_facet_aware_item_id = cs.id AND sl.multi_facet_aware_item_domain_type = 'CodeSet';

INSERT INTO maurodatamapper.terminology.join_codeset_to_facet(codeset_id, version_link_id)
SELECT cs.id AS code_set_id,
       vl.id AS version_link_id
FROM maurodatamapper.terminology.code_set cs
     INNER JOIN maurodatamapper.core.version_link vl ON vl.multi_facet_aware_item_id = cs.id AND vl.multi_facet_aware_item_domain_type = 'CodeSet';

INSERT INTO maurodatamapper.terminology.join_codeset_to_facet(codeset_id, reference_file_id)
SELECT cs.id AS code_set_id,
       rf.id AS reference_file_id
FROM maurodatamapper.terminology.code_set cs
     INNER JOIN maurodatamapper.core.reference_file rf ON rf.multi_facet_aware_item_id = cs.id AND rf.multi_facet_aware_item_domain_type = 'CodeSet';

INSERT INTO maurodatamapper.terminology.join_codeset_to_facet(codeset_id, metadata_id)
SELECT cs.id AS code_set_id,
       md.id AS metadata_id
FROM maurodatamapper.terminology.code_set cs
     INNER JOIN maurodatamapper.core.metadata md ON md.multi_facet_aware_item_id = cs.id AND md.multi_facet_aware_item_domain_type = 'CodeSet';
