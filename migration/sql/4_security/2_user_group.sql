INSERT INTO maurodatamapper.security.user_group(id, version, date_created, last_updated, name, application_group_role_id, created_by, description)
SELECT ug.id,
       ug.version,
       ug.date_created,
       ug.last_updated,
       name,
       NULL AS application_group_role_id,
       u.email_address,
       description
FROM maurodatamapper.metadatacatalogue.user_group ug
     LEFT JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON ug.created_by_id = u.id;



