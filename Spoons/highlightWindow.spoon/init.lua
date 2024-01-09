M = {
   currentOutline = {},
   color = "#ff0000"
}

function M:outlineWindow(window)
            self.currentOutline = hs.canvas.new(window:frame()):appendElements(
               {
                  action = "stroke", padding = 4, type = "rectangle",
                  strokeColor = { hex = self.color },
                  strokeWidth = 4,
                  strokeJoinStyle = "round",
                  withShadow = true,
                }):show()
end

function M:blinkWindow(window)
            hs.canvas.new(window:frame()):appendElements({
                  action = "fill", padding = 4, type = "rectangle",
                  fillColor = { alpha = 0.1, hex = self.color },
                                                                },
               {
                  action = "stroke", padding = 4, type = "rectangle",
                  strokeColor = { hex = self.color },
                  strokeWidth = 8,
                  strokeJoinStyle = "round",
                  withShadow = true,
               }):show():delete(1)
end

function M:clearOutline()
   pcall(function() self.currentOutline:delete() end)
end

function M:focusChanged()
   local focusWatcher = hs.application.watcher.new(function (name, event, obj)
         if (name == "Raycast") then return end
         if (event == hs.application.watcher.activated) then
            self:clearOutline()
            local focusedWindow = obj:focusedWindow()
            self:outlineWindow(focusedWindow)
            self:blinkWindow(focusedWindow)
         end
   end)
focusWatcher:start()    
end

function M:windowMoved()
   hs.window.filter.default:subscribe(hs.window.filter.windowMoved, function(focusedWindow, name, event)
                                 self:clearOutline()
                                 self:outlineWindow(focusedWindow)
   end)
end

function M:start()
   self:focusChanged()
   self:windowMoved()
end

return M
