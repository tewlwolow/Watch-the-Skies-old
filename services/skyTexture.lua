local skyTexture = {}

--------------------------------------------------------------------------------------

local common = require("tew.Watch the Skies.components.common")
local debugLog = common.debugLog
local config = require("tew.Watch the Skies.config")
local WtSdir = "Data Files\\Textures\\tew\\Watch the Skies\\"
local WtC = tes3.worldController.weatherController

--------------------------------------------------------------------------------------

local weathers = {}
weathers.customWeathers = {
	[0] = {},
	[1] = {},
	[2] = {},
	[3] = {},
	[4] = {},
	[5] = {},
	[6] = {},
	[7] = {},
	[8] = {},
	[9] = {},
}
weathers.vanillaWeathers = {
	[0] = "tx_sky_clear.dds",
	[1] = "tx_sky_cloudy.dds",
	[2] = "tx_sky_foggy.dds",
	[3] = "tx_sky_overcast.dds",
	[4] = "tx_sky_rainy.dds",
	[5] = "tx_sky_thunder.dds",
	[6] = "tx_sky_ashstorm.dds",
	[7] = "tx_sky_blight.dds",
	[8] = "tx_bm_sky_snow.dds",
	[9] = "tx_bm_sky_blizzard.dds"
}

--------------------------------------------------------------------------------------

function skyTexture.randomise()
	local weatherNow
	if WtC then
		weatherNow = WtC.currentWeather
	end
	if (WtC.nextWeather) then return end

	-- Check against config chances, do nothing if dice roll determines we should use vanilla instead --
	debugLog("Starting cloud texture randomisation.")
	for index, weather in ipairs(WtC.weathers) do
		if (weatherNow) and (weatherNow.index == index) then goto continue end
			weather.cloudTexture = WtSdir .. weather.name:lower() .. "\\" .. table.choice(weathers.customWeathers[index-1])
			debugLog("Cloud texture path set to: " .. weather.name .. " >> " .. weather.cloudTexture)
		::continue::
	end
end

function skyTexture.init()
	-- Populate data tables with cloud textures --
	for weather, index in pairs(tes3.weather) do
		debugLog("Weather: " .. weather)
		for sky in lfs.dir(WtSdir .. weather) do
			if sky ~= ".." and sky ~= "." then
				if string.endswith(sky, ".dds") or string.endswith(sky, ".tga") then
					table.insert(weathers.customWeathers[index], sky)
					debugLog("File added: " .. sky)
				end
			end
		end
	end

	if config.useVanillaSkyTextures then
		for index, sky in ipairs(weathers.vanillaWeathers) do
			table.insert(weathers.customWeathers[index], sky)
		end
	end

	-- Initially shuffle the cloud textures --
	skyTexture.randomise()
end

function skyTexture.startTimer()
	timer.start{
		duration = common.centralTimerDuration,
		callback = skyTexture.randomise,
		iterations = -1,
		type = timer.game
	}
end

--------------------------------------------------------------------------------------

return skyTexture