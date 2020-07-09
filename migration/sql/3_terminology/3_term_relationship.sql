INSERT INTO maurodatamapper.core.breadcrumb_tree(id, version, domain_type, finalised, domain_id, tree_string, top_breadcrumb_tree, label, parent_id)
SELECT uuid_generate_v4()                                                                    AS id,
       0                                                                                     AS version,
       t.domain_type,
       NULL                                                                                  AS finalised,
       t.id                                                                                  AS domain_id,
       concat(pbt.tree_string, E'\n', t.id, '|', t.domain_type, '|', trt.label, '|', 'null') AS tree_string,
       FALSE                                                                                 AS top_breadcrumb_tree,
       trt.label                                                                             AS label,
       pbt.id                                                                                AS parent_id
FROM maurodatamapper.metadatacatalogue.term_relationship t
     INNER JOIN maurodatamapper.core.breadcrumb_tree pbt ON pbt.domain_id = t.source_term_id
     INNER JOIN maurodatamapper.metadatacatalogue.term_relationship_type trt ON t.relationship_type_id = trt.id;

INSERT INTO maurodatamapper.terminology.term_relationship(id, version, date_created, target_term_id, relationship_type_id, last_updated, path, depth,
                                                          source_term_id, breadcrumb_tree_id, idx, created_by, aliases_string, label, description)
SELECT t.id,
       t.version,
       t.date_created,
       t.target_term_id,
       t.relationship_type_id,
       t.last_updated,
       concat(st.path, '/', t.source_term_id) AS path,
       2                                      AS depth,
       t.source_term_id,
       bt.id                                  AS breadcrumb_tree_id,
       2147483647                             AS idx,
       u.email_address,
       NULL                                   AS aliases_string,
       trt.label                              AS label,
       NULL                                   AS description
FROM maurodatamapper.metadatacatalogue.term_relationship t
     INNER JOIN maurodatamapper.terminology.term st ON st.id = t.source_term_id
     INNER JOIN maurodatamapper.terminology.term_relationship_type trt ON t.relationship_type_id = trt.id
     INNER JOIN maurodatamapper.core.breadcrumb_tree bt ON bt.domain_id = t.id
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON t.created_by_id = u.id;

INSERT INTO maurodatamapper.terminology.join_termrelationship_to_facet(termrelationship_id, classifier_id, annotation_id,
                                                                       semantic_link_id, reference_file_id,
                                                                       metadata_id)
SELECT t.id   AS termrelationship_id,
       NULL   AS classifier_id,
       ann.id AS annotation_id,
       NULL   AS semantic_link_id,
       NULL   AS reference_file_id,
       NULL   AS metadata_id
FROM maurodatamapper.terminology.term_relationship t
     INNER JOIN maurodatamapper.core.annotation ann ON ann.catalogue_item_id = t.id AND ann.catalogue_item_domain_type = 'TermRelationship';

INSERT INTO maurodatamapper.terminology.join_termrelationship_to_facet(termrelationship_id, classifier_id, annotation_id,
                                                                       semantic_link_id, reference_file_id,
                                                                       metadata_id)
SELECT t.id  AS termrelationship_id,
       NULL  AS classifier_id,
       NULL  AS annotation_id,
       sl.id AS semantic_link_id,
       NULL  AS reference_file_id,
       NULL  AS metadata_id
FROM maurodatamapper.terminology.term_relationship t
     INNER JOIN maurodatamapper.core.semantic_link sl ON sl.catalogue_item_id = t.id AND sl.catalogue_item_domain_type = 'TermRelationship';

INSERT INTO maurodatamapper.terminology.join_termrelationship_to_facet(termrelationship_id, classifier_id, annotation_id,
                                                                       semantic_link_id, reference_file_id,
                                                                       metadata_id)
SELECT t.id  AS termrelationship_id,
       NULL  AS classifier_id,
       NULL  AS annotation_id,
       NULL  AS semantic_link_id,
       rf.id AS reference_file_id,
       NULL  AS metadata_id
FROM maurodatamapper.terminology.term_relationship t
     INNER JOIN maurodatamapper.core.reference_file rf ON rf.catalogue_item_id = t.id AND rf.catalogue_item_domain_type = 'TermRelationship';

INSERT INTO maurodatamapper.terminology.join_termrelationship_to_facet(termrelationship_id, classifier_id, annotation_id,
                                                                       semantic_link_id, reference_file_id,
                                                                       metadata_id)
SELECT t.id  AS termrelationship_id,
       NULL  AS classifier_id,
       NULL  AS annotation_id,
       NULL  AS semantic_link_id,
       NULL  AS reference_file_id,
       md.id AS metadata_id
FROM maurodatamapper.terminology.term_relationship t
     INNER JOIN maurodatamapper.core.metadata md ON md.catalogue_item_id = t.id AND md.catalogue_item_domain_type = 'TermRelationship';
