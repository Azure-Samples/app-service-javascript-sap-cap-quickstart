require("dotenv").config({ path: "../.env" })

const cds = require("@sap/cds")
const LOG = cds.log("server.js")

async function autodeploy() {
  const db = await cds.connect.to("db")
  const m = await cds.load("*")
  LOG.info("deploying...")
  await cds.deploy(m).to(db)
}

cds.on("bootstrap", async () => {
  LOG.info("bootstrapping for CDS ENV:", process.env.CDS_ENV)

  const {
    ODATA_USERNAME,
    ODATA_USERPWD,
    APIKEY_HEADERNAME,
    APIKEY,
    SAP_CLIENT,
    POSTGRES_USERPWD,
    POSTGRES_HOSTNAME,
    SKIP_AUTODEPLOY
  } = process.env

  let ODATA_URL = process.env.ODATA_URL
  // remove trailing slash from ODATA_URL
  if (ODATA_URL.endsWith('/')) {
    ODATA_URL = ODATA_URL.slice(0, -1);
  }

  cds.requires.s4_bp.credentials.url = ODATA_URL
  if (ODATA_USERNAME && ODATA_USERPWD) {
    cds.requires.s4_bp.credentials.username = ODATA_USERNAME
    cds.requires.s4_bp.credentials.password = ODATA_USERPWD
    //See possible values: https://sap.github.io/cloud-sdk/api/v3/types/sap_cloud_sdk_connectivity.AuthenticationType.html
    cds.requires.s4_bp.credentials.authentication = "BasicAuthentication"
  } else {
    LOG.info("using only API key due to missing user credentials...")
    cds.requires.s4_bp.credentials.authentication = "NoAuthentication"
  }

  if (APIKEY) {
    LOG.info("assigning api key for header name " + APIKEY_HEADERNAME + "...")
    cds.requires.s4_bp.credentials.headers[APIKEY_HEADERNAME] = APIKEY
  }
  if (SAP_CLIENT) {
    LOG.info("adding sap-client " + SAP_CLIENT + " to OData request...")
    cds.requires.s4_bp.credentials.queries["sap-client"] = SAP_CLIENT
  }

  if (process.env.CDS_ENV && process.env.CDS_ENV !== "development") {
    LOG.info("loading postgres credentials for citus on " + POSTGRES_HOSTNAME + " to cache business partners...")
    cds.env.requires.db.credentials.host = POSTGRES_HOSTNAME
    cds.env.requires.db.credentials.password = POSTGRES_USERPWD
  }

  LOG.info(new Date().toString() + " - starting autodeploy...")
  if (!SKIP_AUTODEPLOY) await autodeploy()
})
