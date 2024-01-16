local M = {}

local thenResetModal = function(fn, modal, run)
    if (run) then
        fn()
        modal:exit()
        return
    end
    return function()
        fn()
        modal:exit()
    end
end

function M.init(metaMod, ctrlMod, cmd, delay, passthrough)
    local metaX = hs.hotkey.modal.new(metaMod, "x", nil)
    
    local passthroughApplications = passthrough or { "Emacs" }

    metaX:bind(
      metaMod, "x", nil,
      thenResetModal(
         function()
             local activeApplication = hs.window.focusedWindow():application()
             for _, app in ipairs(passthroughApplications) do
               if (app == activeApplication:name()) then
                   hs.eventtap.keyStroke(ctrlMod, "g", activeApplication)
               end
             end
             cmd()
         end, metaX, nil))

    function metaX:entered()
        local activeApplication = hs.window.focusedWindow():application()
        for _, app in ipairs(passthroughApplications) do
         if (app == activeApplication:name()) then
             hs.eventtap.keyStroke(metaMod, "x", activeApplication)
             hs.timer.doAfter(delay or 2, function() self:exit() end)
             return
         end
        end
        thenResetModal(cmd, self, true)
    end

    return metaX
end

return M

