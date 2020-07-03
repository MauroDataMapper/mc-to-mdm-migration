INSERT INTO maurodatamapper.datamodel.summary_metadata_report(id, version, date_created, last_updated, report_date, created_by, report_value,
                                                              summary_metadata_id)
SELECT smr.id,
       smr.version,
       smr.date_created,
       smr.last_updated,
       report_date,
       u.email_address,
       report_value,
       summary_metadata_id
FROM maurodatamapper.metadatacatalogue.summary_metadata_report smr
     INNER JOIN maurodatamapper.metadatacatalogue.catalogue_user u ON smr.created_by_id = u.id;
