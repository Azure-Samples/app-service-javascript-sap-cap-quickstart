# CAP as transparent proxy

PoC for using PostgreSQL on the persistence layer acting as a transparent proxy for the S/4 OData Business Partner service.

## get started

```shell
# make sure you have /.env present (copied from /templates/.env)
# and filled in

# either...
## relies on a local dockered pg w/ default credentials
$> cds watch

# ...or...
## works with Azure Cosmos DB for PostgreSQL
$> cds watch --profile hybrid
```

There's an auto-deployment in place that does a `cds deploy` at bootstrap of the CAP server.  
To skip the auto-deployment, set the environment variable `SKIP_AUTODEPLOY` to `true`.

The first request to the entity set (`GET /odata/v4/api-business-partner/BusinessPartners`) will "fill the cache" with _all_ BPs from the connected S/4 system.

"Fill the cache" here refers to storing the BP(s) in the PostgreSQL database and using it for subsequent requests (instead of reaching out to the remote S/4 service) - including updates to the BP.

The Fiori Elements UI is at `http(s)://<host>/capazure/index.html`

_Hint_: add the URL parameter `sap-ui-xx-viewCache=false` to force updates on the Fiori Elements UI (`http(s)://<host>/capazure/index.html?sap-ui-xx-viewCache=false`)

## under the hood

### environments

There are 3 configuration profiles for the DB connection predefined in `/src/.cdsrc.json`:

0. `development`: assumes a local dockerized PostgreSQL DB as defined in `/src/pg.yml`
1. `hybrid`: CAP standard `hybrid` profile extended for Azure's "CosmosDB for PostgreSQL, Citus flavour"
2. `azure`: CAP standard `production` profile adjusted for Azure's "CosmosDB for PostgreSQL, Citus flavour". Intended for deployment only.

For `development` and `hybrid`, the env file in `/.env` is the source for Azure PostgreSQL credentials, in conjunction with `/src/.cdsrc.json`.  
In `production`, the Azure PostgreSQL credentials are provided automatically by the Azure environment.

As mentioned above, set the environment variable `SKIP_AUTODEPLOY` to `true` to skip the auto-deployment of CDS models at server start. Yet the auto-deploy allows you to completely drop all tables and views to start from scratch.

### remote services

One of CAP's convenience capabilites is to [allow querying remote services](https://cap.cloud.sap/docs/guides/using-services#execute-queries) [via CQL](https://cap.cloud.sap/docs/cds/cql), the same way as local ones. 

At design-time, `cds watch` provides mock values from the remote service. After deployment to SAP BTP, the infrastructure (bindings, destinations) takes of connecting the actual backend to the remote service.

In Azure, the infrastructure concept of remote services is different - that's why this example explicity uses the remote service _the same way_ *at both design- and deploy-time*. Yet the remote service is also (just like in the BTP "setup") not served explicitly.

## tests

Manual, `http`-based tests are in `/src/test/req.http`.

A base setup and test for automated tests is in `/src/test/core.test.js` - run it with `npm test` (in forder `/src`).   
The tests use an in-memory SQLite instance and are not run agains PostgreSQL. This ensures better portability and less external dependencies for including the automated tests in a Continuous Integration process.

## monitoring

Once deployed, the CAP app can be monitored via

`$> az webapp log tail --name <app name> --resource-group <resource group>`

## limitations

- The OData Service are annotated with `@odata.draft.enabled` to support Fiori Element's draft functionality. 
  That makes manual, `http`-based updates to an entity very very cumbersome.
- There's no fine-grained cache-control in place - meaning: if a Buisness Partner is updated outside of the app, e.g. via another S/4 app, the changes between the "cached" BP (in PostgreSQL) and the "remote" BP (in S/4) are not checked.
- deleting remote Business Partner by relaying a PostgreSQL-facing `DELETE` is not implemented

## sample measurements

initial load of all BPs (~700), querying the remote service and init'ing the local proxy: 1747 ms  
subsequent load of all BPs, then from pg, acting as local proxy: 79 ms
