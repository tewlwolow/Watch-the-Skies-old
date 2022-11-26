local config = require("tew.Watch the Skies.config")

-- Particle meshes events --
if config.particleMesh then
	local particleMesh = require("tew.Watch the Skies.services.particleMeshes")
	particleMesh.init()
	event.register(tes3.event.weatherTransitionStarted, particleMesh.particleMeshChecker, { priority = -250 })
	event.register(tes3.event.weatherTransitionFinished, particleMesh.particleMeshChecker, { priority = -250 })
	event.register(tes3.event.weatherTransitionImmediate, particleMesh.particleMeshChecker, { priority = -250 })
	event.register(tes3.event.weatherChangedImmediate, particleMesh.particleMeshChecker, { priority = -250 })
	event.register(tes3.event.loaded, particleMesh.particleMeshChecker, { priority = -250 })
	event.register(tes3.event.enterFrame, particleMesh.reColourParticleMesh)
end

if config.skyTexture then
	local skyTexture = require("tew.Watch the Skies.services.skyTexture")
	skyTexture.init()
	event.register(tes3.event.loaded, skyTexture.startTimer)
end

if config.dynamicWeatherChanges then
	local dynamicWeatherChanges = require("tew.Watch the Skies.services.dynamicWeatherChanges")
	dynamicWeatherChanges.init()
	event.register(tes3.event.loaded, dynamicWeatherChanges.startTimer)
end

if config.particleAmount then
	local particleAmount = require("tew.Watch the Skies.services.particleAmount")
	particleAmount.init()
	event.register(tes3.event.loaded, particleAmount.startTimer)
end

if config.cloudSpeed then
	local cloudSpeed = require("tew.Watch the Skies.services.cloudSpeed")
	cloudSpeed.init()
end

if config.seasonalWeather then
	local seasonalWeather = require("tew.Watch the Skies.services.seasonalWeather")
	seasonalWeather.calculate()
	event.register(tes3.event.loaded, seasonalWeather.startTimer)
end

if config.seasonalDaytime then
	local seasonalDaytime = require("tew.Watch the Skies.services.seasonalDaytime")
	seasonalDaytime.calculate()
	event.register(tes3.event.loaded, seasonalDaytime.startTimer)
end

if config.interiorTransitions then
	local interiorTransitions = require("tew.Watch the Skies.services.interiorTransitions")
	event.register(tes3.event.cellChanged, interiorTransitions.onCellChanged, { priority = -150 })
end

if config.customSkyColour then
	local customSkyColour = require("tew.Watch the Skies.services.customSkyColour")
	event.register(tes3.event.loaded, customSkyColour.startTimer)
end