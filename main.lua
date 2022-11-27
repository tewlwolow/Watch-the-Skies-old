local modversion = require("tew\\Watch the Skies\\version")
local version = modversion.version

local function init()
	dofile("Data Files\\MWSE\\mods\\tew\\Watch the Skies\\components\\events.lua")
	mwse.log("[Watch the Skies] Version " .. version .. " initialised.")
end

event.register(tes3.event.initialized, init, { priority = -150 })

-- Registers MCM menu --
event.register(tes3.event.modConfigReady, function()
	dofile("Data Files\\MWSE\\mods\\tew\\Watch the Skies\\mcm.lua")
end)
