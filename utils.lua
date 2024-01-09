local M = {}

function M.tableDiff(a, b)
	-- Find the difference between two tables
	-- Assumes that there is only one difference	local aa = {}
	for k, v in pairs(a) do
		aa[v] = true
	end
	for k, v in pairs(b) do
		aa[v] = nil
	end
	for k, v in pairs(aa) do
		return k
	end
end

function M.bk(...)
	return hs.hotkey.bind(...)
end

function M.strToTable(str)
	t = {}
	for word in string.gmatch(str, "[^%s]+") do
		table.insert(t, word)
	end
	return t
end

function M.runCmd(bin, strArgs)
	args = M.strToTable(strArgs)
	local t = hs.task.new(bin, function(err, stdout, stderr)
		print(err, stdout, stderr)
	end, function(task, stdout, stderr)
		print(stdout, stderr)
		return true
	end, args)
	t:start()
	if tOut then
		print(tOut)
	end
	if tErr then
		print(tErr)
	end
end

function M.r(b, a)
	return function()
		M.runCmd(b, a)
	end
end

function M.applescript(scriptName, run)
   local script = "applescripts/" .. scriptName .. ".applescript"
   if (run) then
      hs.osascript.applescriptFromFile(script)
      return
   end
   return function()
      hs.osascript.applescriptFromFile(script)
   end
end

return M
