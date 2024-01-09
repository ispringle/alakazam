M = {
   currentOutline = {},
   color = "#ff0000"
}

function M:outlineWindow(window)
   self.currentOutline = hs.canvas.new(
      window:frame()):appendElements({
         action = "stroke",
         padding = 4,
         type = "rectangle",
         strokeColor = { alpha = 0.25, hex = self.color },
         strokeWidth = 8,
         strokeJoinStyle = "round",
         withShadow = true
      }):show()
end

function M:blinkWindow(window)
   hs.canvas.new(
      window:frame()):appendElements(
      {action = "fill",
       padding = 4,
       type = "rectangle",
       fillColor = { alpha = 0.1, hex = self.color }},
      {action = "stroke",
       padding = 4,
       type = "rectangle",
       strokeColor = { hex = self.color },
       strokeWidth = 8,
       strokeJoinStyle = "round",
       withShadow = true}
  ):show():delete(1)
end

function M:clearOutline()
   pcall(function() self.currentOutline:delete() end)
end

local winFocus = hs.window.filter.default
local focused = hs.window.filter.windowFocused
local moved = hs.window.filter.windowMoved

function M:focusChanged()
   winFocus:subscribe(
      focused,
      function (window, name, event)
         if (name == "Raycast") then return end
         self:clearOutline()
         self:outlineWindow(window)
         self:blinkWindow(window)
      end)
end

function M:windowMoved()
   winFocus:subscribe(
      moved,
      function(focusedWindow, name, event)
         self:clearOutline()
         self:outlineWindow(focusedWindow)
      end)
end

function M:start()
   self:focusChanged()
   self:windowMoved()
end

return M
