/*
Create required groups
 */
INSERT INTO maurodatamapper.security.user_group(id, version, date_created, last_updated, name, application_group_role_id, created_by, description)
SELECT uuid_generate_v4() AS           id,
       0                  AS           version,
       current_timestamp  AS           date_created,
       current_timestamp  AS           last_updated,
       concat('DataModel_', ci.label, '_migrated-direct-reader'),
       NULL               AS           application_group_role_id,
       'migration@maurodatamapper.com' created_by,
       NULL               AS           description
FROM maurodatamapper.metadatacatalogue.join_data_model_to_readable_catalogue_user jc
     INNER JOIN maurodatamapper.metadatacatalogue.data_model dm ON dm.id = jc.data_model_id
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_item ci ON ci.id = dm.id
GROUP BY ci.label;

INSERT INTO maurodatamapper.security.user_group(id, version, date_created, last_updated, name, application_group_role_id, created_by, description)
SELECT uuid_generate_v4() AS           id,
       0                  AS           version,
       current_timestamp  AS           date_created,
       current_timestamp  AS           last_updated,
       concat('DataModel_', ci.label, '_migrated-direct-writer'),
       NULL               AS           application_group_role_id,
       'migration@maurodatamapper.com' created_by,
       NULL               AS           description
FROM maurodatamapper.metadatacatalogue.join_data_model_to_writeable_catalogue_user jc
     INNER JOIN maurodatamapper.metadatacatalogue.data_model dm ON dm.id = jc.data_model_id
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_item ci ON ci.id = dm.id
GROUP BY ci.label;

/*
 Put users into groups
 */
INSERT INTO maurodatamapper.security.join_catalogue_user_to_user_group(catalogue_user_id, user_group_id)
SELECT DISTINCT
       catalogue_user_id,
       ug.id AS user_group_id
FROM maurodatamapper.metadatacatalogue.join_data_model_to_readable_catalogue_user jc
     INNER JOIN maurodatamapper.metadatacatalogue.data_model dm ON dm.id = jc.data_model_id
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_item ci ON ci.id = dm.id
     INNER JOIN maurodatamapper.security.user_group ug ON ug.name = concat('DataModel_', ci.label, '_migrated-direct-reader');

INSERT INTO maurodatamapper.security.join_catalogue_user_to_user_group(catalogue_user_id, user_group_id)
SELECT DISTINCT
       catalogue_user_id,
       ug.id AS user_group_id
FROM maurodatamapper.metadatacatalogue.join_data_model_to_writeable_catalogue_user jc
     INNER JOIN maurodatamapper.metadatacatalogue.data_model dm ON dm.id = jc.data_model_id
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_item ci ON ci.id = dm.id
     INNER JOIN maurodatamapper.security.user_group ug ON ug.name = concat('DataModel_', ci.label, '_migrated-direct-writer');

/*
Create securable resources using created groups
 */
INSERT INTO maurodatamapper.security.securable_resource_group_role(id, version, securable_resource_id, user_group_id, date_created,
                                                                   securable_resource_domain_type, last_updated, group_role_id,
                                                                   created_by)
SELECT uuid_generate_v4()              AS id,
       0                               AS version,
       jc.data_model_id                AS securable_resource_id,
       ug.id                           AS user_group_id,
       current_timestamp               AS date_created,
       'DataModel'                     AS securable_resource_domain_type,
       current_timestamp               AS last_updated,
       gr.id                           AS group_role_id,
       'migration@maurodatamapper.com' AS created_by
FROM maurodatamapper.metadatacatalogue.join_data_model_to_readable_catalogue_user jc
     INNER JOIN maurodatamapper.metadatacatalogue.data_model dm ON dm.id = jc.data_model_id
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_item ci ON ci.id = dm.id
     INNER JOIN maurodatamapper.security.user_group ug ON ug.name = concat('DataModel_', ci.label, '_migrated-direct-reader'),
     maurodatamapper.security.group_role gr
WHERE gr.name = 'reader';

INSERT INTO maurodatamapper.security.securable_resource_group_role(id, version, securable_resource_id, user_group_id, date_created,
                                                                   securable_resource_domain_type, last_updated, group_role_id,
                                                                   created_by)
SELECT uuid_generate_v4()              AS id,
       0                               AS version,
       jc.data_model_id                AS securable_resource_id,
       ug.id                           AS user_group_id,
       current_timestamp               AS date_created,
       'DataModel'                     AS securable_resource_domain_type,
       current_timestamp               AS last_updated,
       gr.id                           AS group_role_id,
       'migration@maurodatamapper.com' AS created_by
FROM maurodatamapper.metadatacatalogue.join_data_model_to_writeable_catalogue_user jc
     INNER JOIN maurodatamapper.metadatacatalogue.data_model dm ON dm.id = jc.data_model_id
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_item ci ON ci.id = dm.id
     INNER JOIN maurodatamapper.security.user_group ug ON ug.name = concat('DataModel_', ci.label, '_migrated-direct-writer'),
     maurodatamapper.security.group_role gr
WHERE gr.name = 'container_admin';
