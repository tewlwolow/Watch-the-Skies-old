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

-- Change particle mesh colours in real-time --
function particleMesh.reColourParticleMesh()

	-- Bugger off if we don't have all the data needed --
	if not (WtC.currentWeather.name == "Rain" or WtC.currentWeather.name == "Thunderstorm" or WtC.currentWeather.name == "Snow")
		or ((WtC.nextWeather) and not (WtC.nextWeather.name == "Rain" or WtC.nextWeather.name == "Thunderstorm" or WtC.nextWeather.name == "Snow"))
		or not newParticleMesh then
		return
	end

	-- Get fog colour to make the particles match the scene look --
	local weatherColour = WtC.currentFogColor

	-- Preprocess colours a bit, snow should be lighter, rain should look a bit colder --
	local colours
	if (WtC.currentWeather.name) == "Snow" or (WtC.nextWeather and WtC.nextWeather.name == "Snow") then
		colours = {
			r = math.clamp(weatherColour.r + 0.2, 0.1, 0.9),
			g = math.clamp(weatherColour.g + 0.2, 0.1, 0.9),
			b = math.clamp(weatherColour.b + 0.2, 0.1, 0.9)
		}
	else
		colours = {
			r = math.clamp(weatherColour.r + 0.11, 0.1, 0.9),
			g = math.clamp(weatherColour.g + 0.12, 0.1, 0.9),
			b = math.clamp(weatherColour.b + 0.13, 0.1, 0.9)
		}
	end

	-- Set the particle mesh colour via mesh material property --
	local materialProperty = newParticleMesh:getObjectByName("tew_particle").materialProperty
	materialProperty.emissive = colours
	materialProperty.specular = colours
	materialProperty.diffuse = colours
	materialProperty.ambient = colours
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