/*
 Classifier
 */
INSERT INTO maurodatamapper.security.securable_resource_group_role(id, version, securable_resource_id, user_group_id, date_created,
                                                                   securable_resource_domain_type, last_updated, group_role_id, finalised_model,
                                                                   created_by)
SELECT uuid_generate_v4()              AS id,
       0                               AS version,
       jc.classifier_id                AS securable_resource_id,
       user_group_id,
       current_timestamp               AS date_created,
       'Classifier'                    AS securable_resource_domain_type,
       current_timestamp               AS last_updated,
       gr.id                           AS group_role_id,
       NULL                            AS finalised_model,
       'migration@maurodatamapper.com' AS created_by
FROM maurodatamapper.metadatacatalogue.join_classifier_to_readable_user_group jc,
     maurodatamapper.security.group_role gr
WHERE gr.name = 'reader';

INSERT INTO maurodatamapper.security.securable_resource_group_role(id, version, securable_resource_id, user_group_id, date_created,
                                                                   securable_resource_domain_type, last_updated, group_role_id, finalised_model,
                                                                   created_by)
SELECT uuid_generate_v4()              AS id,
       0                               AS version,
       jc.classifier_id                AS securable_resource_id,
       user_group_id,
       current_timestamp               AS date_created,
       'Classifier'                    AS securable_resource_domain_type,
       current_timestamp               AS last_updated,
       gr.id                           AS group_role_id,
       NULL                            AS finalised_model,
       'migration@maurodatamapper.com' AS created_by
FROM maurodatamapper.metadatacatalogue.join_classifier_to_writeable_user_group jc,
     maurodatamapper.security.group_role gr
WHERE gr.name = 'container_admin';

/*
 CodeSet
 */
INSERT INTO maurodatamapper.security.securable_resource_group_role(id, version, securable_resource_id, user_group_id, date_created,
                                                                   securable_resource_domain_type, last_updated, group_role_id, finalised_model,
                                                                   created_by)
SELECT uuid_generate_v4()              AS id,
       0                               AS version,
       jc.code_set_id                  AS securable_resource_id,
       user_group_id,
       current_timestamp               AS date_created,
       'CodeSet'                       AS securable_resource_domain_type,
       current_timestamp               AS last_updated,
       gr.id                           AS group_role_id,
       cs.finalised                    AS finalised_model,
       'migration@maurodatamapper.com' AS created_by
FROM maurodatamapper.metadatacatalogue.join_code_set_to_readable_user_group jc
     INNER JOIN maurodatamapper.metadatacatalogue.code_set cs ON cs.id = jc.code_set_id,
     maurodatamapper.security.group_role gr
WHERE gr.name = 'reader';

INSERT INTO maurodatamapper.security.securable_resource_group_role(id, version, securable_resource_id, user_group_id, date_created,
                                                                   securable_resource_domain_type, last_updated, group_role_id, finalised_model,
                                                                   created_by)
SELECT uuid_generate_v4()              AS id,
       0                               AS version,
       jc.code_set_id                  AS securable_resource_id,
       user_group_id,
       current_timestamp               AS date_created,
       'CodeSet'                       AS securable_resource_domain_type,
       current_timestamp               AS last_updated,
       gr.id                           AS group_role_id,
       cs.finalised                    AS finalised_model,
       'migration@maurodatamapper.com' AS created_by
FROM maurodatamapper.metadatacatalogue.join_code_set_to_writeable_user_group jc
     INNER JOIN maurodatamapper.metadatacatalogue.code_set cs ON cs.id = jc.code_set_id,
     maurodatamapper.security.group_role gr
WHERE gr.name = 'container_admin';

/*
 DataModel
 */
INSERT INTO maurodatamapper.security.securable_resource_group_role(id, version, securable_resource_id, user_group_id, date_created,
                                                                   securable_resource_domain_type, last_updated, group_role_id, finalised_model,
                                                                   created_by)
SELECT uuid_generate_v4()              AS id,
       0                               AS version,
       jc.data_model_id                AS securable_resource_id,
       user_group_id,
       current_timestamp               AS date_created,
       'DataModel'                     AS securable_resource_domain_type,
       current_timestamp               AS last_updated,
       gr.id                           AS group_role_id,
       dm.finalised                    AS finalised_model,
       'migration@maurodatamapper.com' AS created_by
FROM maurodatamapper.metadatacatalogue.join_data_model_to_readable_user_group jc
     INNER JOIN maurodatamapper.metadatacatalogue.data_model dm ON dm.id = jc.data_model_id,
     maurodatamapper.security.group_role gr
WHERE gr.name = 'reader';

INSERT INTO maurodatamapper.security.securable_resource_group_role(id, version, securable_resource_id, user_group_id, date_created,
                                                                   securable_resource_domain_type, last_updated, group_role_id, finalised_model,
                                                                   created_by)
SELECT uuid_generate_v4()              AS id,
       0                               AS version,
       jc.data_model_id                AS securable_resource_id,
       user_group_id,
       current_timestamp               AS date_created,
       'DataModel'                     AS securable_resource_domain_type,
       current_timestamp               AS last_updated,
       gr.id                           AS group_role_id,
       dm.finalised                    AS finalised_model,
       'migration@maurodatamapper.com' AS created_by
FROM maurodatamapper.metadatacatalogue.join_data_model_to_writeable_user_group jc
     INNER JOIN maurodatamapper.metadatacatalogue.data_model dm ON dm.id = jc.data_model_id,
     maurodatamapper.security.group_role gr
WHERE gr.name = 'container_admin';

/*
 Folder
 */
INSERT INTO maurodatamapper.security.securable_resource_group_role(id, version, securable_resource_id, user_group_id, date_created,
                                                                   securable_resource_domain_type, last_updated, group_role_id, finalised_model,
                                                                   created_by)
SELECT uuid_generate_v4()              AS id,
       0                               AS version,
       jc.folder_id                    AS securable_resource_id,
       user_group_id,
       current_timestamp               AS date_created,
       'Folder'                        AS securable_resource_domain_type,
       current_timestamp               AS last_updated,
       gr.id                           AS group_role_id,
       NULL                            AS finalised_model,
       'migration@maurodatamapper.com' AS created_by
FROM maurodatamapper.metadatacatalogue.join_folder_to_readable_user_group jc,
     maurodatamapper.security.group_role gr
WHERE gr.name = 'reader';

INSERT INTO maurodatamapper.security.securable_resource_group_role(id, version, securable_resource_id, user_group_id, date_created,
                                                                   securable_resource_domain_type, last_updated, group_role_id, finalised_model,
                                                                   created_by)
SELECT uuid_generate_v4()              AS id,
       0                               AS version,
       jc.folder_id                    AS securable_resource_id,
       user_group_id,
       current_timestamp               AS date_created,
       'Folder'                        AS securable_resource_domain_type,
       current_timestamp               AS last_updated,
       gr.id                           AS group_role_id,
       NULL                            AS finalised_model,
       'migration@maurodatamapper.com' AS created_by
FROM maurodatamapper.metadatacatalogue.join_folder_to_writeable_user_group jc,
     maurodatamapper.security.group_role gr
WHERE gr.name = 'container_admin';

/*
 Terminology
 */
INSERT INTO maurodatamapper.security.securable_resource_group_role(id, version, securable_resource_id, user_group_id, date_created,
                                                                   securable_resource_domain_type, last_updated, group_role_id, finalised_model,
                                                                   created_by)
SELECT uuid_generate_v4()              AS id,
       0                               AS version,
       jc.terminology_id               AS securable_resource_id,
       user_group_id,
       current_timestamp               AS date_created,
       'Terminology'                   AS securable_resource_domain_type,
       current_timestamp               AS last_updated,
       gr.id                           AS group_role_id,
       t.finalised                     AS finalised_model,
       'migration@maurodatamapper.com' AS created_by
FROM maurodatamapper.metadatacatalogue.join_terminology_to_readable_user_group jc
     INNER JOIN maurodatamapper.metadatacatalogue.data_model t ON t.id = jc.terminology_id,
     maurodatamapper.security.group_role gr
WHERE gr.name = 'reader';

INSERT INTO maurodatamapper.security.securable_resource_group_role(id, version, securable_resource_id, user_group_id, date_created,
                                                                   securable_resource_domain_type, last_updated, group_role_id, finalised_model,
                                                                   created_by)
SELECT uuid_generate_v4()              AS id,
       0                               AS version,
       jc.terminology_id               AS securable_resource_id,
       user_group_id,
       current_timestamp               AS date_created,
       'Terminology'                   AS securable_resource_domain_type,
       current_timestamp               AS last_updated,
       gr.id                           AS group_role_id,
       t.finalised                     AS finalised_model,
       'migration@maurodatamapper.com' AS created_by
FROM maurodatamapper.metadatacatalogue.join_terminology_to_writeable_user_group jc
     INNER JOIN maurodatamapper.metadatacatalogue.data_model t ON t.id = jc.terminology_id,
     maurodatamapper.security.group_role gr
WHERE gr.name = 'container_admin';