# MC to MDM Migration

This repository details how to migrate a Metadata Catalogue application database into a Mauro Data Mapper database.

## Manual Process

Please see the documents in the `guide` folder for further information.

## Automated Process

You can use one of the 2 available scripts in the top of this repository to run the migration from start to finish

You have 2 options as with the manual process documents, depending on if you're running Metadata Catalogue and Mauro Data Mapper inside or
outside Docker.

The scripts execute the stages described in the guide, so if you're unsure as to what parameters you should feed in then please read the guides
to find out more.

*The scripts all execute using the defaults as if you have built the system using Docker*

### Docker Based PostgreSQL
```bash
# Help/Usage
./run-complete-migration-docker.sh --help
# Default parameters run
./run-complete-migration-docker.sh
```

### Remote/Local PostgreSQL

```bash
# Help/Usage
./run-complete-migration-remote.sh --help
# Default parameters run
./run-complete-migration-remote.sh
```

## Notes

Please be aware that at this point in time the following information is **not** migrated

* Terminologies
* DataFlows

These are still being migrated and will be included as the plugins are made available.
