const cds = require("@sap/cds/lib")
const { SELECT } = require("@sap/cds/lib/ql/cds-ql")
const { GET, PATCH, expect, data } = cds.test("serve", "all", "--in-memory") //> we want the flex of sqlite in-memory for testing

process.env.DEBUG && jest.setTimeout(100000) && console.info("DEBUG: on && extended timeout to 100s")

describe("initial caching", () => {
  it("should cache all BPs on first request", async () => {
    jest.setTimeout(10000) //> we're querying the remote S/4 API here

    const priorToCache = await SELECT.from("BusinessPartnerLocal")
    expect(priorToCache.length).to.eql(0)

    const s4Response = await GET("/odata/v4/api-business-partner/BusinessPartnersLocal")
    expect(s4Response.status).to.eql(200)
    const nrOfBPs = s4Response.data.value.length
    expect(nrOfBPs).to.be.greaterThanOrEqual(1)

    const afterCache = await SELECT.from("BusinessPartnerLocal")
    expect(afterCache.length).to.eql(nrOfBPs)

    await data.reset()
  })
})