package uk.ac.ox.softeng.maurodatamapper.mc.migration

class UrlMappings {

    static mappings = {

        final List<String> DEFAULT_EXCLUDES = ['patch', 'create', 'edit']
        final List<String> DEFAULT_EXCLUDES_AND_UPDATING = ['patch', 'create', 'edit', 'update']
        final List<String> INDEX_ONLY = ['index']
        final List<String> READ_ONLY_INCLUDES = ['index', 'show']

        group '/api', {
            /**
             * Resources endpointsPOS
             * These endpoints are to allow access to top level resources and their full lists.
             */

            group "/catalogueUsers/$catalogueUserId", {
                '/image'(redirect: [uri                   : "/api/userImageFiles/$catalogueUserId",
                                    keepParamsWhenRedirect: true, permanent: true])
                put '/approveRegistration'(redirect: [uri                   : '/api/admin/catalogueUsers/approveRegistration',
                                                      keepParamsWhenRedirect: true, permanent: true])
                put '/rejectRegistration'(redirect: [uri                   : '/api/admin/catalogueUsers/approveRegistration',
                                                     keepParamsWhenRedirect: true, permanent: true])
                get '/resetPasswordLink'(redirect: [uri                   : "/api/catalogueUsers/$catalogueUserId/resetPassword",
                                                    keepParamsWhenRedirect: true, permanent: true])
                put '/adminPasswordReset'(redirect: [uri                   : '/api/admin/catalogueUsers/approveRegistration',
                                                     keepParamsWhenRedirect: true, permanent: true])
            }
            group '/catalogueUsers', {
                get '/pending'(redirect: [uri                   : '/api/admin/catalogueUsers/pending',
                                          keepParamsWhenRedirect: true, permanent: true])
                /*
                get '/pending?count=true'(redirect: [uri                   : '/api/admin/catalogueUsers/pendingCount',
                                          keepParamsWhenRedirect: true, permanent: true])
                 */
                post '/adminRegister'(redirect: [uri                   : '/api/admin/catalogueUsers/adminRegister',
                                                 keepParamsWhenRedirect: true, permanent: true])
                get "/search/$searchTerm?"(redirect: [uri                   : "/api/admin/catalogueUsers/search?searchTerm=$searchTerm",
                                                      keepParamsWhenRedirect: true, permanent: true])
                get "/userExists/$emailAddress"(redirect: [uri                   : "/api/admin/catalogueUsers/userExists/$emailAddress",
                                                           keepParamsWhenRedirect: true, permanent: true])
            }

            group "/classifiers/$classifierId", {
                /**
                 * User based permissions are gone
                 */
                put "/$type/$share/$shareId?"(redirect: [uri                   :
                                                             "/api/classifiers/$classifierId/groupRoles/$groupRoleId/userGroups/$shareId",
                                                         keepParamsWhenRedirect: true, permanent: true])
                delete "/$type/$share/$shareId"(redirect: [uri                   :
                                                               "/api/classifiers/$classifierId/groupRoles/$groupRoleId/userGroups/$shareId",
                                                           keepParamsWhenRedirect: true, permanent: true])

                get '/permissions'(redirect: [view: "/gone"])


                /*
                You will need to send one of:
                 - dataModels
                 - dataClasses
                 - dataElements
                 - primitiveTypes
                 - enumerationTypes
                 - referenceTypes
                 - enumerationValues
                 */
                '/catalogueItems'(redirect: [uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/classifiers",
                                             keepParamsWhenRedirect: true, permanent: true])
                '/terminologies'(redirect: [uri                   : "/api/terminologies/$terminologyId/classifiers",
                                            keepParamsWhenRedirect: true, permanent: true])
                '/codeSets'(redirect: [uri                   : "/api/codeSets/$codeSetId/classifiers",
                                       keepParamsWhenRedirect: true, permanent: true])
                '/terms'(redirect: [uri                   : "/api/terms/$termId/classifiers",
                                    keepParamsWhenRedirect: true, permanent: true])
            }

            /*
            //TODO codesets are not implemented yet
            '/codeSets'(resources: 'codeSet', excludes: DEFAULT_EXCLUDES) {
                put "/$type/$share/$shareId?"(controller: 'codeSet', action: 'share')
                delete "/$type/$share/$shareId"(controller: 'codeSet', action: 'share')
                put '/readByEveryone'(controller: 'codeSet', action: 'readByEveryone')
                delete '/readByEveryone'(controller: 'codeSet', action: 'readByEveryone')
                put '/readByAuthenticated'(controller: 'codeSet', action: 'readByAuthenticated')
                delete '/readByAuthenticated'(controller: 'codeSet', action: 'readByAuthenticated')

                get '/permissions'(controller: 'permissions', action: 'permissions')


                put '/finalise'(controller: 'codeSet', action: 'finalise')
                put '/newDocumentationVersion'(controller: 'codeSet', action: 'newDocumentationVersion')
                put '/newVersion'(controller: 'codeSet', action: 'newVersion')
                put "/folder/$folderId"(controller: 'codeSet', action: 'changeFolder')


                '/edits'(resources: 'edit', includes: INDEX_ONLY)
                '/terms'(resources: 'term', includes: INDEX_ONLY)
                put "/terms/$termId"(controller: 'codeSet', action: 'alterTerms')
                delete "/terms/$termId"(controller: 'codeSet', action: 'alterTerms')
            }
*/

            post "/dataModels"(redirect: [uri                   : "/api/folders/$folderId/dataModels",
                                          keepParamsWhenRedirect: true, permanent: true])
            group "/dataModels/$dataModelId", {

                /**
                 * User based permissions are gone
                 */
                put "/$type/$share/$shareId?"(redirect: [uri                   :
                                                             "/api/dataModels/$dataModelId/groupRoles/$groupRoleId/userGroups/$shareId",
                                                         keepParamsWhenRedirect: true, permanent: true])
                delete "/$type/$share/$shareId"(redirect: [uri                   :
                                                               "/api/dataModels/$dataModelId/groupRoles/$groupRoleId/userGroups/$shareId",
                                                           keepParamsWhenRedirect: true, permanent: true])

                get '/permissions'(redirect: [view: "/gone"])

                put '/newVersion'(redirect: [uri                   : "/api/dataModels/$dataModelId/newModelVersion",
                                             keepParamsWhenRedirect: true, permanent: true])



                /*
                 * the dataModelId should ALWAYS be the target datamodel for any action involving a write
                 */
                /*
                TODO DataFlows are not implemented yet
                '/dataFlows'(resources: 'dataFlow', excludes: DEFAULT_EXCLUDES) {

                    get "/export/$exporterNamespace/$exporterName/$exporterVersion"(controller: 'dataFlow', action: 'exportDataFlow')
                    put '/diagramLayout'(controller: 'dataFlow', action: 'updateDiagramLayout')

                    '/dataFlowComponents'(resources: 'dataFlowComponent', excludes: DEFAULT_EXCLUDES) {
                        /**
                         * type = source|target
                         * /
                        put "/${type}/$dataElementId"(controller: 'dataFlowComponent', action: 'alterElements')
                        delete "/${type}/$dataElementId"(controller: 'dataFlowComponent', action: 'alterElements')
                    }

                    get '/dataClassFlows'(controller: 'dataFlow', action: 'dataClassFlows')
                    get "/dataClassFlows/$dataClassId/dataFlowComponents"(controller: 'dataFlowComponent', action: 'index')
                }

                post "/dataFlows/export/$exporterNamespace/$exporterName/$exporterVersion"(controller: 'dataFlow', action: 'exportDataFlows')
                post "/dataFlows/import/$importerNamespace/$importerName/$importerVersion"(controller: 'dataFlow', action: 'importDataFlows')
        */
            }
            /*
            TODO profiles are not implemented yet
                        group '/profiles', {
                            post "/$profileNamespace/$profileName/customSearch"(controller: 'profile', action: 'customSearch')
                            get "/$profileNamespace/$profileName/$customAction/$id?"(controller: 'profile', action: 'customAction')

                        }

                        group '/dataModels', {
                            get "/profile/$profileNamespace/$profileName/$profileVersion?"(controller: 'metadata', action: 'listDataModelProfiles')
                            get "/profile/values/$profileNamespace/$profileName/$profileVersion?"(controller: 'metadata', action: 'getAllValues')

                        }
            */
            get "/tree"(redirect: [uri                   : "/api/tree/folders",
                                   keepParamsWhenRedirect: true, permanent: true])
            /*
        You will need to send one of:
         - dataModels
         - dataClasses
         - terms
         */
            get "/tree/$id"(redirect: [uri                   : "/api/tree/folders/$DOMAIN_TYPE_ENDPOINT/$id",
                                       keepParamsWhenRedirect: true, permanent: true])
            get "/tree/search/$search"(redirect: [uri                   : "/api/folders/tree/search/$search",
                                                  keepParamsWhenRedirect: true, permanent: true])

            /**
             * CatalogueItem resource endpoints
             * These are endpoints which are designed to allow access to a single resource to manipulate it and its content
             * We don't want to be able to list these resources as lists should be obtained from their parents
             * However they have nesting access which means we can't realistically allow for an "infinite" nest so we allow direct access to them
             */
            group '/catalogueItems', {
                post '/search'(redirect: [view: "/notImplemented"])
                get '/search'(redirect: [view: "/notImplemented"])
            }

            /*
               You will need to send one of:
                - dataModels
                - dataClasses
                - dataElements
                - primitiveTypes
                - enumerationTypes
                - referenceTypes
                - enumerationValues
                */
            get "/catalogueItems/$catalogueItemId/semanticLinks"(redirect: [
                uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/semanticLinks",
                keepParamsWhenRedirect: true, permanent: true])
            post "/catalogueItems/$catalogueItemId/semanticLinks"(redirect: [
                uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/semanticLinks",
                keepParamsWhenRedirect: true, permanent: true])
            get "/catalogueItems/$catalogueItemId/semanticLinks/$id"(redirect: [
                uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/semanticLinks/$id",
                keepParamsWhenRedirect: true, permanent: true])
            delete "/catalogueItems/$catalogueItemId/semanticLinks/$id"(redirect: [
                uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/semanticLinks/$id",
                keepParamsWhenRedirect: true, permanent: true])
            put "/catalogueItems/$catalogueItemId/semanticLinks/$id"(redirect: [
                uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/semanticLinks/$id",
                keepParamsWhenRedirect: true, permanent: true])

            /**
             * Facet resource endpoints are ones shared across the CIs and Terminologies
             */
            /*
               You will need to send one of:
                - dataModels
                - dataClasses
                - dataElements
                - primitiveTypes
                - enumerationTypes
                - referenceTypes
                - enumerationValues
                - terminologies
                - terms
                - codeSets
                */
            group "/facets/$facetOwnerId", {

                get "/metadata"(redirect: [
                    uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/metadata",
                    keepParamsWhenRedirect: true, permanent: true])
                post "/metadata"(redirect: [
                    uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/metadata",
                    keepParamsWhenRedirect: true, permanent: true])
                get "/metadata/$id"(redirect: [
                    uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/metadata/$id",
                    keepParamsWhenRedirect: true, permanent: true])
                delete "/metadata/$id"(redirect: [
                    uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/metadata/$id",
                    keepParamsWhenRedirect: true, permanent: true])
                put "/metadata/$id"(redirect: [
                    uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/metadata/$id",
                    keepParamsWhenRedirect: true, permanent: true])


                get "/annotations"(redirect: [
                    uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/annotations",
                    keepParamsWhenRedirect: true, permanent: true])
                post "/annotations"(redirect: [
                    uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/annotations",
                    keepParamsWhenRedirect: true, permanent: true])
                get "/annotations/$id"(redirect: [
                    uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/annotations/$id",
                    keepParamsWhenRedirect: true, permanent: true])
                delete "/annotations/$id"(redirect: [
                    uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/annotations/$id",
                    keepParamsWhenRedirect: true, permanent: true])

                group "/annotations/$annotationId", {
                    get "/annotations"(redirect: [
                        uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/annotations/$annotationId/annotations",
                        keepParamsWhenRedirect: true, permanent: true])
                    post "/annotations"(redirect: [
                        uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/annotations/$annotationId/annotations",
                        keepParamsWhenRedirect: true, permanent: true])
                    get "/annotations/$id"(redirect: [
                        uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/annotations/$annotationId/annotations/$id",
                        keepParamsWhenRedirect: true, permanent: true])
                    delete "/annotations/$id"(redirect: [
                        uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/annotations/$annotationId/annotations/$id",
                        keepParamsWhenRedirect: true, permanent: true])
                }

                get "/referenceFiles"(redirect: [
                    uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/referenceFiles",
                    keepParamsWhenRedirect: true, permanent: true])
                post "/referenceFiles"(redirect: [
                    uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/referenceFiles",
                    keepParamsWhenRedirect: true, permanent: true])
                get "/referenceFiles/$id"(redirect: [
                    uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/referenceFiles/$id",
                    keepParamsWhenRedirect: true, permanent: true])
                delete "/referenceFiles/$id"(redirect: [
                    uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/referenceFiles/$id",
                    keepParamsWhenRedirect: true, permanent: true])
                put "/referenceFiles/$id"(redirect: [
                    uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/referenceFiles/$id",
                    keepParamsWhenRedirect: true, permanent: true])


                /*
               You will need to send one of:
                - dataModels
                - dataClasses
                - dataElements
                - primitiveTypes
                - enumerationTypes
                - referenceTypes
                */
                get "/summaryMetadata"(redirect: [
                    uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/summaryMetadata",
                    keepParamsWhenRedirect: true, permanent: true])
                post "/summaryMetadata"(redirect: [
                    uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/summaryMetadata",
                    keepParamsWhenRedirect: true, permanent: true])
                get "/summaryMetadata/$id"(redirect: [
                    uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/summaryMetadata/$id",
                    keepParamsWhenRedirect: true, permanent: true])
                delete "/summaryMetadata/$id"(redirect: [
                    uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/summaryMetadata/$id",
                    keepParamsWhenRedirect: true, permanent: true])
                put "/summaryMetadata/$id"(redirect: [
                    uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/summaryMetadata/$id",
                    keepParamsWhenRedirect: true, permanent: true])

                group "/summaryMetadata/$summaryMetadataId", {
                    get "/summaryMetadataReports"(redirect: [
                        uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/summaryMetadata/$summaryMetadataId" +
                                                "/summaryMetadataReports",
                        keepParamsWhenRedirect: true, permanent: true])
                    post "/summaryMetadataReports"(redirect: [
                        uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/summaryMetadata/$summaryMetadataId" +
                                                "/summaryMetadataReports",
                        keepParamsWhenRedirect: true, permanent: true])
                    get "/summaryMetadataReports/$id"(redirect: [
                        uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/summaryMetadata/$summaryMetadataId" +
                                                "/summaryMetadataReports/$id",
                        keepParamsWhenRedirect: true, permanent: true])
                    delete "/summaryMetadataReports/$id"(redirect: [
                        uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/summaryMetadata/$summaryMetadataId" +
                                                "/summaryMetadataReports/$id",
                        keepParamsWhenRedirect: true, permanent: true])
                    put "/summaryMetadataReports/$id"(redirect: [
                        uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/summaryMetadata/$summaryMetadataId" +
                                                "/summaryMetadataReports/$id",
                        keepParamsWhenRedirect: true, permanent: true])
                }

                /*
                TODO profiles are not yet implemented
                get "/profile/$profileNamespace/$profileName/$profileVersion?"(controller: 'metadata', action: 'getProfile')
                post "/profile/$profileNamespace/$profileName/$profileVersion?"(controller: 'metadata', action: 'setProfile')
                 */


            }

            /**
             * Feature resource endpoints are ones shared across the CIs and Terminologies
             */
            group "", {
                get "/features/${featureComponentId}/classifiers"(redirect: [
                    uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/classifiers",
                    keepParamsWhenRedirect: true, permanent: true])
                post "/features/${featureComponentId}/classifiers"(redirect: [
                    uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/classifiers",
                    keepParamsWhenRedirect: true, permanent: true])
                delete "/features/${featureComponentId}/classifiers/id"(redirect: [
                    uri                   : "/api/$DOMAIN_TYPE_ENDPOINT/$catalogueItemId/classifiers/$id",
                    keepParamsWhenRedirect: true, permanent: true])
            }

            /**
             * Non-resource endpoints
             */
            group '/authentication', {
                get '/isValidSession'(redirect: [uri                   : "/api/session/isAuthenticated",
                                                 keepParamsWhenRedirect: true, permanent: true])
            }

            group '/admin', {
                delete '/logoutAllUsers'(redirect: [view: "/gone"])

                /*
                TODO not yet implemented
                group '/dataModels', {
                    get '/documentSuperseded'(controller: 'dataModel', action: 'listVersionSuperseded')
                    get '/modelSuperseded'(controller: 'dataModel', action: 'listModelSuperseded')
                    get '/deleted'(controller: 'dataModel', action: 'listDeleted')
                }

                group '/terminologies', {
                    get '/documentSuperseded'(controller: 'terminology', action: 'listVersionSuperseded')
                    get '/modelSuperseded'(controller: 'terminology', action: 'listModelSuperseded ')
                    get '/deleted'(controller: 'terminology', action: 'listDeleted')
                }
                 */
                group '/plugins', {
                    get '/importers'(redirect: [uri                   : "/api/admin/providers/importers",
                                                keepParamsWhenRedirect: true, permanent: true])
                    get '/dataLoaders'(redirect: [uri                   : "/api/admin/providers/dataLoaders",
                                                  keepParamsWhenRedirect: true, permanent: true])
                    get '/emailers'(redirect: [uri                   : "/api/admin/providers/emailers",
                                               keepParamsWhenRedirect: true, permanent: true])
                    get '/exporters'(redirect: [uri                   : "/api/admin/providers/exporters",
                                                keepParamsWhenRedirect: true, permanent: true])
                    /*
                    // TODO profiles not yet implemented
                    get '/profiles'(controller: 'adminPlugin', action: 'profilePlugins')
                     */
                }
            }

            group '/public', {
                get '/defaultDataTypeProviders'(redirect: [uri                   : "/api/dataModels/providers/defaultDataTypeProviders",
                                                           keepParamsWhenRedirect: true, permanent: true])

                group '/plugins', {
                    get '/dataModelExporters'(redirect: [uri                   : "/api/dataModels/providers/exporters",
                                                         keepParamsWhenRedirect: true, permanent: true])
                    get '/dataModelImporters'(redirect: [uri                   : "/api/dataModels/providers/importers",
                                                         keepParamsWhenRedirect: true, permanent: true])

                    /*
                    // TODO DataFlows not yet implemented
                    get '/dataFlowExporters'(controller: 'plugin', action: 'dataFlowExporterPlugins')
                    get '/dataFlowImporters'(controller: 'plugin', action: 'dataFlowImporterPlugins')
                     */
                }
            }


            group "/folders/$folderId", {
                '/dataModels'(redirect: [view: "/gone"])
                '/codeSets'(redirect: [view: "/gone"])
                '/terminologies'(redirect: [view: "/gone"])
                /**
                 * User based permissions are gone
                 */
                put "/$type/$share/$shareId?"(redirect: [uri                   :
                                                             "/api/dataModels/$dataModelId/groupRoles/$groupRoleId/userGroups/$shareId",
                                                         keepParamsWhenRedirect: true, permanent: true])
                delete "/$type/$share/$shareId"(redirect: [uri                   :
                                                               "/api/dataModels/$dataModelId/groupRoles/$groupRoleId/userGroups/$shareId",
                                                           keepParamsWhenRedirect: true, permanent: true])

                get '/permissions'(redirect: [view: "/gone"])

                post '/search'(redirect: [view: "/notImplemented"])
                get '/search'(redirect: [view: "/notImplemented"])
            }

            /*
            TODO Terminology not yet implemented
            '/terminologies'(resources: 'terminology', excludes: DEFAULT_EXCLUDES) {
                '/terms'(resources: 'term', excludes: DEFAULT_EXCLUDES) {
                    '/termRelationships'(resources: 'termRelationship', includes: READ_ONLY_INCLUDES)
                    '/semanticLinks'(resources: 'semanticLink', excludes: DEFAULT_EXCLUDES)
                    get '/tree'(controller: 'term', action: 'tree')
                }
                get "/terms/search/$search?"(controller: 'term', action: 'search')

                '/termRelationshipTypes'(resources: 'termRelationshipType', includes: READ_ONLY_INCLUDES) {
                    '/termRelationships'(resources: 'termRelationship', includes: READ_ONLY_INCLUDES)
                }

                /**
                 * type = read|write
                 * share = group|user   `
                 * shareId = id of share
                 *
                 * If shareId is not supplied then the body must contain email, first & last names and a user will be created
                 * /
                 put "/$type/$share/$shareId?"(controller: 'terminology', action: 'share')
                 delete "/$type/$share/$shareId"(controller: 'terminology', action: 'share')
                 put '/readByEveryone'(controller: 'terminology', action: 'readByEveryone')
                 delete '/readByEveryone'(controller: 'terminology', action: 'readByEveryone')
                 put '/readByAuthenticated'(controller: 'terminology', action: 'readByAuthenticated')
                 delete '/readByAuthenticated'(controller: 'terminology', action: 'readByAuthenticated')

                 get '/permissions'(controller: 'permissions', action: 'permissions')

                 '/edits'(resources: 'edit', includes: INDEX_ONLY)

                 put '/finalise'(controller: 'terminology', action: 'finalise')
                 put '/newDocumentationVersion'(controller: 'terminology', action: 'newDocumentationVersion')
                 put '/newVersion'(controller: 'terminology', action: 'newVersion')

                 put "/folder/$folderId"(controller: 'terminology', action: 'changeFolder')

                 get "/export/$type"(controller: 'terminology', action: 'exportTerminology')

                 get '/tree'(controller: 'terminology', action: 'tree')}group '/terminologies', {post "/import/$type"(controller: 'terminology',
                 action: 'importTerminology')}*/
            }
        }
    }
