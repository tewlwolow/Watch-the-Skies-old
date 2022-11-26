local common = {}
local config = require("tew.Watch the Skies.config")
local debugLogOn = config.debugLogOn
local modversion = require("tew.Watch the Skies.version")
local version = modversion.version

common.centralTimerDuration = 8

function common.debugLog(message)
	if debugLogOn then
		mwse.log("[Watch the Skies " .. version .. "] " .. string.format("%s", message))
	end
end

return common