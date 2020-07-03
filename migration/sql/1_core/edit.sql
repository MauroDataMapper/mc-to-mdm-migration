INSERT INTO maurodatamapper.core.edit(id, version, date_created, last_updated, resource_domain_type, resource_id, created_by, description)
SELECT e.id,
       e.version,
       e.date_created,
       e.last_updated,
       'Classifier'      AS resource_domain_type,
       cls.classifier_id AS resource_id,
       u.email_address,
       e.description
FROM maurodatamapper.metadatacatalogue.edit e
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON e.created_by_id = u.id
     INNER JOIN maurodatamapper.metadatacatalogue.join_classifier_to_edits cls ON e.id = cls.edit_id;

INSERT INTO maurodatamapper.core.edit(id, version, date_created, last_updated, resource_domain_type, resource_id, created_by, description)
SELECT e.id,
       e.version,
       e.date_created,
       e.last_updated,
       'CodeSet'      AS resource_domain_type,
       cs.code_set_id AS resource_id,
       u.email_address,
       e.description
FROM maurodatamapper.metadatacatalogue.edit e
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON e.created_by_id = u.id
     INNER JOIN maurodatamapper.metadatacatalogue.join_code_set_to_edits cs ON e.id = cs.edit_id;

INSERT INTO maurodatamapper.core.edit(id, version, date_created, last_updated, resource_domain_type, resource_id, created_by, description)
SELECT e.id,
       e.version,
       e.date_created,
       e.last_updated,
       'DataModel'      AS resource_domain_type,
       dm.data_model_id AS resource_id,
       u.email_address,
       e.description
FROM maurodatamapper.metadatacatalogue.edit e
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON e.created_by_id = u.id
     INNER JOIN maurodatamapper.metadatacatalogue.join_data_model_to_edits dm ON e.id = dm.edit_id;

INSERT INTO maurodatamapper.core.edit(id, version, date_created, last_updated, resource_domain_type, resource_id, created_by, description)
SELECT e.id,
       e.version,
       e.date_created,
       e.last_updated,
       'Folder'    AS resource_domain_type,
       f.folder_id AS resource_id,
       u.email_address,
       e.description
FROM maurodatamapper.metadatacatalogue.edit e
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON e.created_by_id = u.id
     INNER JOIN maurodatamapper.metadatacatalogue.join_folder_to_edits f ON e.id = f.edit_id;

INSERT INTO maurodatamapper.core.edit(id, version, date_created, last_updated, resource_domain_type, resource_id, created_by, description)
SELECT e.id,
       e.version,
       e.date_created,
       e.last_updated,
       'Terminology'    AS resource_domain_type,
       t.terminology_id AS resource_id,
       u.email_address,
       e.description
FROM maurodatamapper.metadatacatalogue.edit e
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON e.created_by_id = u.id
     INNER JOIN maurodatamapper.metadatacatalogue.join_terminology_to_edits t ON e.id = t.edit_id;

INSERT INTO maurodatamapper.core.edit(id, version, date_created, last_updated, resource_domain_type, resource_id, created_by, description)
SELECT e.id,
       e.version,
       e.date_created,
       e.last_updated,
       'UserGroup'      AS resource_domain_type,
       ug.user_group_id AS resource_id,
       u.email_address,
       e.description
FROM maurodatamapper.metadatacatalogue.edit e
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON e.created_by_id = u.id
     INNER JOIN maurodatamapper.metadatacatalogue.join_user_group_to_edits ug ON e.id = ug.edit_id