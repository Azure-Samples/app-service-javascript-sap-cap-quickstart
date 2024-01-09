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
## queries credentials on the fly from your azure vault
## requires all Azure setup to be done!
$> cds watch --profile hybrid
```

There's an auto-deployment in place that does a `cds deploy` at bootstrap of the CAP server.  
To skip the auto-deployment, set the environment variable `SKIP_AUTODEPLOY` to `true`.

Now query either all BPs via  
`GET /odata/v4/api-business-partner/BusinessPartners`  
or selected ones via their BP Id  
`GET /odata/v4/api-business-partner/BusinessPartners('1000034')`  
in order to "fill the cache" with all or the selected BP respectively.

"Fill the cache" here refers to storing the BP(s) in the PostgreSQL database and using it for subsequent requests (instead of reaching out to the remote S/4 service)

## under the hood

There are 3 configuration profiles for the DB connection predefined in `/src/.cdsrc.json`:

0. `development`: assumes a local dockerized PostgreSQL DB as defined in `/src/pg.yml`
1. `hybrid`: CAP standard `hybrid` profile extended for Azure's "CosmosDB for PostgreSQL, Citrus flavour"
2. `production`: CAP standard `production` profile extended for Azure's "CosmosDB for PostgreSQL, Citrus flavour". Intended for deployment only.

On CAP start (`cds {watch, run, serve}`), the Azure PostgreSQL credentials are retrieved from the environment.  
For `development` and `hybrid`, the env file in `/.env` is the source for these, in conjunction with `/src/.cdsrc.json`.  
In `production`, the Azure PostgreSQL credentials are provided automatically by the Azure environment.

As mentioned above, set the environment variable `SKIP_AUTODEPLOY` to `true` to skip the auto-deployment of CDS models at server start.

## limitations

if a BP is queried with `$select`ed properties only and is not cached, the BP is stored with the `$select`ed properties only.  
 Subsequent queries will only return the selected properties.

## sample measure

initial load of all BPs, querying the remote service and init'ing the local proxy: 1747 ms
subsequent load of all BPs, then from pg, acting as local proxy: 79 ms
