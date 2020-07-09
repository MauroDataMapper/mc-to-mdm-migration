INSERT INTO maurodatamapper.terminology.join_codeset_to_term(term_id, codeset_id)
SELECT term_id,
       code_set_id
FROM maurodatamapper.metadatacatalogue.join_code_set_to_term