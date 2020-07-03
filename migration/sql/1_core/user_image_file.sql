INSERT INTO maurodatamapper.core.user_image_file(id, version, file_size, date_created, last_updated, file_type, file_name, user_id, file_contents,
                                                 created_by)
SELECT cf.id,
       cf.version,
       cf.file_size,
       cf.date_created,
       cf.last_updated,
       cf.file_type,
       cf.file_name,
       pp.id AS user_id,
       cf.file_contents,
       u.email_address
FROM maurodatamapper.metadatacatalogue.catalogue_file cf
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON cf.created_by_id = u.id
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user pp ON cf.id = pp.profile_picture_id -- Only want to copy user image files
