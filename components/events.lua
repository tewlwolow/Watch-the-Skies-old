local config = require("tew.Watch the Skies.config")
local weatherController = require("tew.Watch the Skies.controllers.weather")


if config.randomiseParticleMeshes then
	event.register("weatherTransitionStarted", particleMeshChecker, { priority = -250 })
	event.register("weatherTransitionFinished", particleMeshChecker, { priority = -250 })
	event.register("weatherTransitionImmediate", particleMeshChecker, { priority = -250 })
	event.register("weatherChangedImmediate", particleMeshChecker, { priority = -250 })
	event.register("loaded", particleMeshChecker, { priority = -250 })
	event.register("enterFrame", reColourParticleMesh)
end