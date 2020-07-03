INSERT INTO maurodatamapper.core.edit(id, version, date_created, last_updated, resource_domain_type, resource_id, created_by, description)
SELECT e.id,
       e.version,
       e.date_created,
       e.last_updated,
       CASE
           WHEN cls.classifier_id IS NOT NULL
               THEN 'Classifier'
           WHEN cs.code_set_id IS NOT NULL
               THEN 'CodeSet'
           WHEN dm.data_model_id IS NOT NULL
               THEN 'DataModel'
           WHEN f.folder_id IS NOT NULL
               THEN 'Folder'
           WHEN t.terminology_id IS NOT NULL
               THEN 'Terminology'
           WHEN ug.user_group_id IS NOT NULL
               THEN 'UserGroup'
       END                                                                                                            AS resource_domain_type,
       coalesce(cls.classifier_id, cs.code_set_id, dm.data_model_id, f.folder_id, t.terminology_id, ug.user_group_id) AS resource_id,
       u.email_address,
       e.description
FROM maurodatamapper.metadatacatalogue.edit e
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON e.created_by_id = u.id
     LEFT JOIN maurodatamapper.metadatacatalogue.join_classifier_to_edits cls ON e.id = cls.edit_id
     LEFT JOIN maurodatamapper.metadatacatalogue.join_code_set_to_edits cs ON e.id = cs.edit_id
     LEFT JOIN maurodatamapper.metadatacatalogue.join_data_model_to_edits dm ON e.id = dm.edit_id
     LEFT JOIN maurodatamapper.metadatacatalogue.join_folder_to_edits f ON e.id = f.edit_id
     LEFT JOIN maurodatamapper.metadatacatalogue.join_terminology_to_edits t ON e.id = t.edit_id
     LEFT JOIN maurodatamapper.metadatacatalogue.join_user_group_to_edits ug ON e.id = ug.edit_id