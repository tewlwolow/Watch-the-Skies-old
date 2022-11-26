local particleMesh = {}

--------------------------------------------------------------------------------------

local common = require("tew.Watch the Skies.components.common")
local debugLog = common.debugLog
local WtC = tes3.worldController.weatherController
local newParticleMesh
local particlesPath = "Data Files\\Meshes\\tew\\Watch the Skies\\particles"

--------------------------------------------------------------------------------------

local particles = {
	["rain"] = {},
	["snow"] = {}
}

local weatherChecklist = {
	["Rain"] = "rain",
	["Thunderstorm"] = "rain",
	["Snow"] = "snow"
}

--------------------------------------------------------------------------------------

function particleMesh.init()
	for particleType in lfs.dir(particlesPath) do
		if particleType and particleType ~= ".." and particleType ~= "." then
			for particle in lfs.dir(particlesPath .. "\\" .. particleType) do
				if particle and particle ~= ".." and particle ~= "." and string.endswith(particle:lower(), ".nif") then
					table.insert(particles[particleType], particle)
				end
			end
		end
	end
end

-- Randomise particle mesh --
function particleMesh.changeParticleMesh(particleType)

	-- A dumb timer here to actually allow background data to be available --
	timer.start {
		type = timer.game,
		duration = 0.00001,
		callback = function()

			-- Get particle mesh from pre-filled array and load it --
			local randomParticleMesh = table.choice(particles[particleType])
			newParticleMesh = tes3.loadMesh("tew\\Watch the Skies\\particles\\" .. particleType .. "\\" .. randomParticleMesh):clone()

			-- Simple inline function to swap the nodes, preserving visibility --
			local function swapNode(particle)
				local old = particle.object
				particle.rainRoot:detachChild(old)

				local new = newParticleMesh:clone()
				particle.rainRoot:attachChild(new)
				new.appCulled = old.appCulled

				particle.object = new
			end

			-- Swap both active and inactive particles to ward off sudden changes --
			for _, particle in pairs(WtC.particlesActive) do
				swapNode(particle)
			end
			for _, particle in pairs(WtC.particlesInactive) do
				swapNode(particle)
			end

			-- Update the root node to reflect the changes made --
			WtC.sceneRainRoot:updateEffects()
			debugLog("Rain mesh changed to " .. randomParticleMesh)
		end
	}
end

-- Check if we have the weather that warrants particle change --
function particleMesh.particleMeshChecker()
	timer.start {
		type = timer.game,
		duration = 0.001,
		callback = function()
			local weatherNow
			-- Also check if we're transitioning to next weather --
			if WtC.nextWeather then
				weatherNow = WtC.nextWeather
				-- Match rain and thunderstorm with rain particles, and snow with snow particles --
				local checked = weatherChecklist[weatherNow.name]
				if checked ~= nil then
					timer.start {
						duration = 0.25,
						callback = function()
							particleMesh.changeParticleMesh(checked)
						end,
						type = timer.game,
					}
				end
			else
				weatherNow = WtC.currentWeather
				local checked = weatherChecklist[weatherNow.name]
				if checked ~= nil then
					particleMesh.changeParticleMesh(checked)
				end
			end
		end
	}
end

--------------------------------------------------------------------------------------

return particleMesh