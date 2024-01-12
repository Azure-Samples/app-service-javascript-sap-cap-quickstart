const cds = require("@sap/cds")
class HealthCheckService extends cds.ApplicationService {
  async init() {
    this.on("READ", "health", async (req) => {
      return { pid: 0, status: "OK" }
    })
    return super.init()
  }
}

module.exports = HealthCheckService
