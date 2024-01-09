class BuPaService extends cds.ApplicationService {
  async query({ fromCache, req }) {
    const { SELECT: _SELECT } = req.query[Object.getOwnPropertySymbols(req.query)[1]]
    const BusinessPartner = fromCache
      ? cds.entities.BusinessPartner
      : cds.entities["API_BUSINESS_PARTNER.BusinessPartners"]
    if (req.params.length > 0) {
      // single BP
      const { columns } = _SELECT
      const q = SELECT.one.from(BusinessPartner).where(req.params[0]).columns(columns)
      const entity = fromCache ? await q : await (await cds.connect.to("s4_bp")).run(q)
      return entity
    } else {
      // all BPs
      const { limit, orderBy, where } = _SELECT
      const q = SELECT.from(BusinessPartner).where(where).limit(limit).orderBy(orderBy)
      const entitySet = fromCache ? await q : await (await cds.connect.to("s4_bp")).run(q)
      entitySet["$count"] = entitySet.length
      return entitySet
    }
  }

  async cache(entry) {
    const { BusinessPartner } = cds.entities
    await INSERT.into(BusinessPartner).entries(entry)
  }

  async update({ cache: inCache, entry }) {
    const BusinessPartner = inCache
      ? cds.entities.BusinessPartner
      : cds.entities["API_BUSINESS_PARTNER.BusinessPartners"]
    const q = UPDATE(BusinessPartner).with(entry).where({ BusinessPartner: entry.BusinessPartner })
    const target = inCache ? cds : await cds.connect.to("s4_bp")
    return target.run(q)
  }

  async init() {
    this.on("READ", "BusinessPartners", async (req) => {
      let result = await this.query({ fromCache: true, req })
      if (!result || result.length === 0) {
        result = await this.query({ fromCache: false, req })
        if (result) {
          await this.cache(result)
        }
      }
      return result
    })
    this.on("UPDATE", "BusinessPartners", async (req) => {
      try {
        await Promise.all([this.update({ cache: true, entry: req.data }), this.update({ cache: false, entry: req.data })])
      } catch (err) {
        return req.error(500, err)
      }
      return req.data
    })

    return super.init()
  }
}
module.exports = BuPaService
