const cds = require("@sap/cds")
class HealthService extends cds.ApplicationService {
  async init() {
    this.on("READ", "check", async (req) => {
      return { pid: 0, status: "OK" }
    })
    return super.init()
  }
}

module.exports = HealthService
