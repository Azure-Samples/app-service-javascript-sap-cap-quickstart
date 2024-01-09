const cds = require("@sap/cds/lib")
const { SELECT } = require("@sap/cds/lib/ql/cds-ql")
const { GET, PATCH, expect, data } = cds.test("serve", "all", "--in-memory") //> we want the flex of sqlite in-memory for testing

process.env.DEBUG && jest.setTimeout(100000) && console.info("DEBUG: on && extended timeout to 100s")

describe("initial caching", () => {
  it("should cache all BPs on first request", async () => {
    jest.setTimeout(10000) //> we're querying the remote S/4 API here

    const priorToCache = await SELECT.from("BusinessPartner")
    expect(priorToCache.length).to.eql(0)

    const s4Response = await GET("/odata/v4/api-business-partner/BusinessPartners")
    expect(s4Response.status).to.eql(200)
    const nrOfBPs = s4Response.data.value.length
    expect(nrOfBPs).to.be.greaterThanOrEqual(1)

    const afterCache = await SELECT.from("BusinessPartner")
    expect(afterCache.length).to.eql(nrOfBPs)

    await data.reset()
  })

  it("should cache a single BPs on first request", async () => {
    jest.setTimeout(10000) //> we're querying the remote S/4 API here

    const priorToCache = await SELECT.from("BusinessPartner")
    expect(priorToCache.length).to.eql(0)

    const s4Response = await GET("/odata/v4/api-business-partner/BusinessPartners('1000034')")
    expect(s4Response.data.BusinessPartner).to.eql("1000034")

    const afterCache = await SELECT.from("BusinessPartner")
    expect(afterCache.length).to.eql(1)

    await data.reset()
  })

  // http://localhost:4004/odata/v4/api-business-partner/BusinessPartners?$filter=FirstName%20eq%20%27John%27
  it.todo("should support caching of multiple BPs by OData $filter")

  // http://localhost:4004/odata/v4/api-business-partner/BusinessPartners('1000034')?$select=IsMale,IsFemale
  it.todo("should cache entire BP if not yet cached and queried with selective properties only")
})

describe("update", () => {
  it("should relay update on 'cached' BP to S/4", async () => {
    const FirstName = "Martin"
    const LastName = "Pankraz"

    await GET("/odata/v4/api-business-partner/BusinessPartners('1000034')") //> trigger cache

    await PATCH("/odata/v4/api-business-partner/BusinessPartners('1000034')", {
      FirstName,
      LastName
    })

    const s4Response = await GET("/odata/v4/api-business-partner/BusinessPartners('1000034')")
    expect(s4Response.data.FirstName).to.eql(FirstName)
    expect(s4Response.data.LastName).to.eql(LastName)

    const remote = await cds.connect.to("s4_bp")
    const remoteResponse = await remote.run(
      SELECT.one.from("API_BUSINESS_PARTNER.BusinessPartners").where({ BusinessPartner: "1000034" })
    )
    expect(remoteResponse.FirstName).to.eql(FirstName)
    expect(remoteResponse.LastName).to.eql(LastName)

    // "reset" data
    await PATCH("/odata/v4/api-business-partner/BusinessPartners('1000034')", {
      FirstName: "John",
      LastName: "Smith"
    })
  })
})
