TRUNCATE TABLE maurodatamapper.security.securable_resource_group_role CASCADE;

-- Bootstrapping will add any development users back in but the admin user, unlogged user and administrators group are the bare minimum and
-- must exist
DELETE
FROM maurodatamapper.security.join_catalogue_user_to_user_group jcutug
WHERE user_group_id <> (SELECT id
                        FROM maurodatamapper.security.user_group
                        WHERE name = 'administrators') AND
      catalogue_user_id <> (SELECT id
                            FROM maurodatamapper.security.catalogue_user
                            WHERE email_address = 'admin@maurodatamapper.com');

DELETE
FROM maurodatamapper.security.catalogue_user
WHERE email_address NOT IN ('admin@maurodatamapper.com', 'unlogged_user@mdm-core.com');

DELETE
FROM maurodatamapper.security.user_group
WHERE name <> 'administrators';