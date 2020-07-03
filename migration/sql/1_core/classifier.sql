INSERT INTO maurodatamapper.core.classifier(id, version, date_created, last_updated, path, depth, parent_classifier_id,
                                            readable_by_authenticated_users, created_by, readable_by_everyone, label, description)
SELECT cls.id,
       cls.version,
       cls.date_created,
       cls.last_updated,
       cls.path,
       cls.depth - 1 AS depth,
       cls.parent_classifier_id,
       cls.readable_by_authenticated,
       u.email_address,
       cls.readable_by_everyone,
       cls.label,
       cls.description
FROM maurodatamapper.metadatacatalogue.classifier cls
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON cls.created_by_id = u.id