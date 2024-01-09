require("hs.ipc")
require('reloadConfig')

local configLog = hs.logger.new("Config")
local utils = require('utils')

laptopScreen = hs.screen.find("Built%-in Retina Display")
midScreen = hs.screen.find("LG HDR 4K")
leftScreen = hs.screen.find("DELL P2414H")

local ctrl = "ctrl"
local meta = "alt"
local cmd = "cmd"
local shift = "shift"
local meh = { ctrl, alt, shift }
local super = { ctrl, meta, cmd }
local hyper = { ctrl, meta, cmd, shift }

local bk = utils.bk
bk(hyper, "d", "Toggle: Dark-mode", utils.applescript("toggle-dark-mode.applescript"))

local metaX = require("meta-x").init({meta}, {ctrl}, utils.applescript("raycast/open"))

spoonList = {
	{
		name = "SpoonInstall",
		uri = "https://github.com/Hammerspoon/Spoons/raw/master/Spoons/SpoonInstall.spoon.zip",
	},
}
--[[
table.insert(spoonList, {
	name = "hhtwm",
	uri = "https://github.com/szymonkaliski/hhtwm.git",
	path = "Spoons/hhtwm",
})   
--]]

local spoonManager = require('spoonManager')
spoonManager:init(configLog, reloadConfig)
spoonManager.installMaybe(spoonList)

hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true
Install = spoon.SpoonInstall
Install:andUse("ColorPicker", {
	hotkeys = {
		show = { hyper, "c" },
	},
	config = {
		show_in_menubar = false,
	},
	start = true,
})

Install:andUse("ClipboardTool", {
	config = {
		pase_on_select = true,
		show_copied_alert = false,
		show_in_menubar = false,
	},
	hotkeys = {
		toggle_clipboard = { hyper, "v" },
	},
	start = true,
})

local hlWin = require('highlightWindow')
hlWin:start()
