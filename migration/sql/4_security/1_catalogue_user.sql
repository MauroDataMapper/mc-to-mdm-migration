INSERT INTO maurodatamapper.security.catalogue_user(id, version, pending, salt, date_created, first_name, profile_picture_id, last_updated,
                                                    organisation, reset_token, disabled, job_title, email_address, user_preferences, password,
                                                    created_by, temp_password, last_name, last_login)
SELECT cu.id,
       cu.version,
       CASE cu.user_role
           WHEN 'PENDING'
               THEN TRUE
           ELSE FALSE
       END                                                       AS pending,
       cu.salt,
       cu.date_created,
       cu.first_name,
       cu.profile_picture_id,
       cu.last_updated,
       cu.organisation,
       cu.reset_token,
       cu.disabled,
       cu.job_title,
       cu.email_address,
       cu.user_preferences,
       cu.password,
       coalesce(u.email_address, 'migraton@maurodatamapper.com') AS created_by,
       cu.temp_password,
       cu.last_name,
       cu.last_login
FROM maurodatamapper.metadatacatalogue.catalogue_user cu
     LEFT JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON cu.created_by_id = u.id;