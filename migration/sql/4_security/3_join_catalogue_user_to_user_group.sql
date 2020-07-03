-- Add all administrator users to the default administrators group
INSERT INTO maurodatamapper.security.join_catalogue_user_to_user_group(catalogue_user_id, user_group_id)
SELECT cu.id,
       ug.id
FROM maurodatamapper.metadatacatalogue.catalogue_user cu,
     maurodatamapper.security.user_group ug
WHERE cu.user_role = 'ADMINISTRATOR' AND
      ug.name = 'administrators';

-- Add users to existing groups
INSERT INTO maurodatamapper.security.join_catalogue_user_to_user_group(catalogue_user_id, user_group_id)
SELECT catalogue_user_id,
       user_group_id
FROM maurodatamapper.metadatacatalogue.join_catalogue_user_to_user_group