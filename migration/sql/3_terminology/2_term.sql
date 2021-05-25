INSERT INTO maurodatamapper.core.breadcrumb_tree(id, version, domain_type, finalised, domain_id, tree_string, top_breadcrumb_tree, label, parent_id)
SELECT uuid_generate_v4()                                                                                             AS id,
       0                                                                                                              AS version,
       t.domain_type,
       NULL                                                                                                           AS finalised,
       t.id                                                                                                           AS domain_id,
       concat(pbt.tree_string, E'\n', t.id, '|', t.domain_type, '|', concat(t.code, ': ', t.definition), '|', 'null') AS tree_string,
       FALSE                                                                                                          AS top_breadcrumb_tree,
       concat(t.code, ': ', t.definition)                                                                             AS label,
       pbt.id                                                                                                         AS parent_id
FROM maurodatamapper.metadatacatalogue.term t
     INNER JOIN maurodatamapper.core.breadcrumb_tree pbt ON pbt.domain_id = t.terminology_id;

INSERT INTO maurodatamapper.terminology.term(id, version, date_created, url, definition, terminology_id, is_parent, code, last_updated, path, depth,
                                             breadcrumb_tree_id, idx, created_by, aliases_string, label, description)
SELECT t.id,
       t.version,
       t.date_created,
       t.url,
       t.definition,
       t.terminology_id,
       FALSE                              AS is_parent,
       t.code,
       t.last_updated,
       concat('/', t.terminology_id)      AS path,
       CASE
           WHEN depth IS NULL
               THEN -2147483647
           WHEN depth = 0
               THEN 2147483647
           ELSE depth
       END                                AS depth,
       bt.id                              AS breadcrumb_tree_id,
       2147483647                         AS idx,
       u.email_address,
       aliases_string,
       concat(t.code, ': ', t.definition) AS label,
       description
FROM maurodatamapper.metadatacatalogue.term t
     INNER JOIN maurodatamapper.core.breadcrumb_tree bt ON bt.domain_id = t.id
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON t.created_by_id = u.id;

INSERT INTO maurodatamapper.terminology.join_term_to_facet(term_id, classifier_id, annotation_id, semantic_link_id, reference_file_id,
                                                           metadata_id)
SELECT t.id AS term_id,
       classifier_id,
       NULL AS annotation_id,
       NULL AS semantic_link_id,
       NULL AS reference_file_id,
       NULL AS metadata_id
FROM maurodatamapper.terminology.term t
     INNER JOIN maurodatamapper.metadatacatalogue.join_term_to_classifier jt ON jt.term_id = t.id;

INSERT INTO maurodatamapper.terminology.join_term_to_facet(term_id, classifier_id, annotation_id, semantic_link_id, reference_file_id,
                                                           metadata_id)
SELECT t.id   AS term_id,
       NULL   AS classifier_id,
       ann.id AS annotation_id,
       NULL   AS semantic_link_id,
       NULL   AS reference_file_id,
       NULL   AS metadata_id
FROM maurodatamapper.terminology.term t
     INNER JOIN maurodatamapper.core.annotation ann ON ann.multi_facet_aware_item_id = t.id AND ann.multi_facet_aware_item_domain_type = 'Term';

INSERT INTO maurodatamapper.terminology.join_term_to_facet(term_id, classifier_id, annotation_id, semantic_link_id, reference_file_id,
                                                           metadata_id)
SELECT t.id  AS term_id,
       NULL  AS classifier_id,
       NULL  AS annotation_id,
       sl.id AS semantic_link_id,
       NULL  AS reference_file_id,
       NULL  AS metadata_id
FROM maurodatamapper.terminology.term t
     INNER JOIN maurodatamapper.core.semantic_link sl ON sl.multi_facet_aware_item_id = t.id AND sl.multi_facet_aware_item_domain_type = 'Term';

INSERT INTO maurodatamapper.terminology.join_term_to_facet(term_id, classifier_id, annotation_id, semantic_link_id, reference_file_id,
                                                           metadata_id)
SELECT t.id  AS term_id,
       NULL  AS classifier_id,
       NULL  AS annotation_id,
       NULL  AS semantic_link_id,
       rf.id AS reference_file_id,
       NULL  AS metadata_id
FROM maurodatamapper.terminology.term t
     INNER JOIN maurodatamapper.core.reference_file rf ON rf.multi_facet_aware_item_id = t.id AND rf.multi_facet_aware_item_domain_type = 'Term';

INSERT INTO maurodatamapper.terminology.join_term_to_facet(term_id, classifier_id, annotation_id, semantic_link_id, reference_file_id,
                                                           metadata_id)
SELECT t.id  AS term_id,
       NULL  AS classifier_id,
       NULL  AS annotation_id,
       NULL  AS semantic_link_id,
       NULL  AS reference_file_id,
       md.id AS metadata_id
FROM maurodatamapper.terminology.term t
     INNER JOIN maurodatamapper.core.metadata md ON md.multi_facet_aware_item_id = t.id AND md.multi_facet_aware_item_domain_type = 'Term';
