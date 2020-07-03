INSERT INTO maurodatamapper.core.email(id, version, sent_to_email_address, successfully_sent, body, date_time_sent, email_service_used,
                                       failure_reason, subject)
SELECT id,
       version,
       sent_to_email_address,
       successfully_sent,
       body,
       date_time_sent,
       email_service_used,
       failure_reason,
       subject
FROM maurodatamapper.metadatacatalogue.email