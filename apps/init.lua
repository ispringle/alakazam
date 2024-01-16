local activated = hs.application.watcher.activated
local deactivated = hs.application.watcher.deactivated

local ctrlG = hs.hotkey.new({"ctrl"}, "g", nil, function()
    local activeApplication = hs.window.focusedWindow():application()
    hs.eventtap.keyStroke(nil, "escape", activeApplication)
end)

local apps = {
Raycast = {
[activated] = function() ctrlG:enable() end,
[deactivated] = function() ctrlG:disable() end,
}
}

function appHandler(name, event, obj)
    if (apps[name] and apps[name][event]) then
        apps[name][event]()
    end
end 

appWatcher = hs.application.watcher.new(appHandler)

appWatcher:start()
