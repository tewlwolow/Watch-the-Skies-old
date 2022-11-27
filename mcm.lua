local configPath = "Watch the Skies"
local config = require("tew.Watch the Skies.config")
local modversion = require("tew.Watch the Skies.version")
local version = modversion.version

local function registerVariable(id)
    return mwse.mcm.createTableVariable {
        id = id,
        table = config
    }
end

local template = mwse.mcm.createTemplate {
    name = "Watch the Skies",
    headerImagePath = "\\Textures\\tew\\Watch the Skies\\WtS_logo.tga" }

local page = template:createPage { label = "Main Settings" }
page:createCategory {
    label = "Watch the Skies " .. version .. " by tewlwolow.\nLua-based weather overhaul.\n\nSettings:",
}
page:createYesNoButton {
    label = "Enable debug mode?",
    variable = registerVariable("debugLogOn"),
    restartRequired = true
}
page:createYesNoButton {
    label = "Enable randomised cloud textures?",
    variable = registerVariable("skyTexture"),
    restartRequired = true
}
page:createYesNoButton {
    label = "Use vanilla sky textures as well?",
    variable = registerVariable("useVanillaSkyTextures"),
    restartRequired = true
}
page:createYesNoButton {
    label = "Enable randomised hours between weather changes?",
    variable = registerVariable("dynamicWeatherChanges"),
    restartRequired = true
}
page:createYesNoButton {
    label = "Enable weather changes in interiors?",
    variable = registerVariable("interiorTransitions"),
    restartRequired = true
}
page:createYesNoButton {
    label = "Enable seasonal weather?",
    variable = registerVariable("seasonalWeather"),
    restartRequired = true
}
page:createYesNoButton {
    label = "Enable seasonal daytime hours?",
    variable = registerVariable("seasonalDaytime"),
    restartRequired = true
}
page:createYesNoButton {
    label = "Randomise max particles?",
    variable = registerVariable("particleAmount"),
    restartRequired = true
}
page:createYesNoButton {
    label = "Randomise clouds speed?",
    variable = registerVariable("cloudSpeed"),
    restartRequired = true
}
page:createDropdown {
	label = "Cloud speed mode:",
	options = {
		{ label = "Vanilla", value = 100 },
		{ label = "Skies .iv", value = 500 }
	},
	variable = registerVariable("cloudSpeedMode"),
    restartRequired = true
}
page:createYesNoButton {
    label = "Randomise rain and snow particle meshes?",
    variable = registerVariable("particleMesh"),
    restartRequired = true
}
page:createYesNoButton {
    label = "Use different sky colour calculations (recommended with my WA preset - experimental)",
    variable = registerVariable("customSkyColour"),
    restartRequired = true
}

template:saveOnClose(configPath, config)
mwse.mcm.register(template)
