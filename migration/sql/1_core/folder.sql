INSERT INTO maurodatamapper.core.folder(id, version, date_created, last_updated, path, deleted, depth, readable_by_authenticated_users,
                                        parent_folder_id, created_by, readable_by_everyone, label, description, class)
SELECT f.id,
       f.version,
       f.date_created,
       f.last_updated,
       f.path,
       f.deleted,
       f.depth - 1 AS depth,
       f.readable_by_authenticated,
       f.parent_folder_id,
       u.email_address,
       f.readable_by_everyone,
       f.label,
       f.description,
       'uk.ac.ox.softeng.maurodatamapper.core.container.Folder' as class
FROM maurodatamapper.metadatacatalogue.folder f
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON f.created_by_id = u.id