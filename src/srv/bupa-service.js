const cds = require("@sap/cds")
const LOG = cds.log("cache")

class BuPaService extends cds.ApplicationService {
  async isCached({ req }) {
    const { limit, orderBy } = req.query.SELECT
    const { BusinessPartnerLocal } = cds.entities
    const q = SELECT.from(BusinessPartnerLocal).limit(limit).orderBy(orderBy)
    const entitySet = await q
    LOG.info(`retrieved ${entitySet.length} Business Partners from "cache"`)
    return entitySet.length > 0
  }

  async cache(entry) {
    const BusinessPartner = cds.entities["API_BUSINESS_PARTNER.BusinessPartnersRemote"]
    const { BusinessPartnerLocal } = cds.entities
    if (!entry) { //> we're working the entire entity set
      const q = SELECT.from(BusinessPartner)
      const allBPs = await (await cds.connect.to("s4_bp")).run(q)
      await INSERT.into(BusinessPartnerLocal).entries(allBPs)
      LOG.info(`retrieved and "cached" ${allBPs.length} Business Partners from S/4`)
    } else { //> we're working a single entity
      const q = SELECT.from(BusinessPartner).where({ BusinessPartner: entry.BusinessPartner })
      const singleBP = await (await cds.connect.to("s4_bp")).run(q)
      const { BusinessPartnerLocal } = cds.entities
      singleBP[0].ID = entry.ID //> re-equip remote entry with local UUID
      await UPSERT.into(BusinessPartnerLocal).entries(singleBP)
      LOG.info(`re-"cached" Business Partner ${entry.BusinessPartner}`)
    }
  }

  async updateRemote({ entry }) {
    // update remote
    const BusinessPartner = cds.entities["API_BUSINESS_PARTNER.BusinessPartnersRemote"]
    const q = UPDATE(BusinessPartner).with(entry).where({ BusinessPartner: entry.BusinessPartner })
    await (await cds.connect.to("s4_bp")).run(q)
    LOG.info(`updated remote Business Partner ${entry.BusinessPartner}`)
    // re-read remote and update "cache"
    const _entry = { ID: entry.ID, ...entry} //> re-equip entry with local UUID for further processing...
    await this.cache(_entry)
  }

  async init() {
    this.before("READ", "BusinessPartnersLocal", async (req) => {
      // only looking at entity sets here
      if (req.params.length > 0) return

      const cached = await this.isCached({ req })
      if (!cached) {
        LOG.info("caching Business Partners...")
        await this.cache()
      }
    })

    this.after("UPDATE", "BusinessPartnersLocal", async (req) => {
      LOG.info(`updating remote Business Partner ${req.BusinessPartner}...`)
      await this.updateRemote({ entry: req })
    })

    return super.init()
  }
}
module.exports = BuPaService
