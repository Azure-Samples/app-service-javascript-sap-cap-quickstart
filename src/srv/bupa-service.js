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

  /**
   * prep a business partner read from the remote S/4 service to be UPSERTed as a local entry
   * 
   * @param {s4_bp.A_BusinessPartner} entry 
   * @param {guid} augmentedId 
   * @returns a copy of the entry with all to_* properties removed, augmented with ID and cachedOn, ready for UPSERT
   */
  mangle(entry, augmentedId) {
    const _entry = { ...entry }
    for (const [key, _] of Object.entries(_entry)) {
      if (key.startsWith("to_") /** these are the odata nav properties... */) {
        delete _entry[key]
      }
    }
    _entry.ID = augmentedId
    _entry.cachedOn = new Date
    return _entry
  }

  async cache(entry) {
    const BusinessPartnerRemote = cds.entities["s4_bp.A_BusinessPartner"]
    const { BusinessPartnerLocal } = cds.entities
    if (!entry) { //> we're working the entire entity set
      const q = SELECT.from(BusinessPartnerRemote)
      const allBPs = await (await cds.connect.to("s4_bp")).run(q)
      await INSERT.into(BusinessPartnerLocal).entries(allBPs)
      LOG.info(`retrieved and "cached" ${allBPs.length} Business Partners from S/4`)
    } else { //> we're working a single entity
      const q = SELECT.from(BusinessPartnerRemote).where({ BusinessPartner: entry.BusinessPartner })
      const singleBP = await (await cds.connect.to("s4_bp")).run(q)
      const { BusinessPartnerLocal } = cds.entities
      const _bp = this.mangle(singleBP[0], entry.ID)
      await UPSERT.into(BusinessPartnerLocal).entries(_bp)
      LOG.info(`re-"cached" Business Partner ${entry.BusinessPartner}`)
    }
  }

  async updateRemote({ entry }) {
    const _id = entry.ID //> store for later re-ue
    const __entry = { ...entry } //> make a copy of the entry
    delete __entry.ID //> remote doesn't know about cds.uuid
    delete __entry.cachedOn //> remote doesn't have this
    
    // update remote
    const BusinessPartner = cds.entities["s4_bp.A_BusinessPartner"]
    const q = UPDATE(BusinessPartner).with(__entry).where({ BusinessPartner: entry.BusinessPartner })
    await (await cds.connect.to("s4_bp")).run(q)
    LOG.info(`updated remote Business Partner ${entry.BusinessPartner}`)

    // forward re-read remote and update "cache"
    const _entry = { ID: _id, ...entry} //> re-equip entry with local UUID for further processing...
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
