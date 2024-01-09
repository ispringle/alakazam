reloadConfig = {
	watcher = {},
}

function reloadConfig.reloader(paths)
	doReload = false
	for _, file in pairs(paths) do
		if file:sub(-4) == ".lua" then
			print("A Lua configuration file has changed. Reloading...")
			doReload = true
		end
	end
	if not doReload then
		print("No Lua configuration files have changed. Skipping reload...")
		return
	end
	hs.reload()
end

-- Config Reloader:1 ends here
-- [[file:../org/dotfiles.org::*Config Reloader][Config Reloader:2]]
hammerspoonDir = os.getenv("HOME") .. "/.hammerspoon/"

function reloadConfig.init()
	reloadConfig.watcher = hs.pathwatcher.new(hammerspoonDir, reloadConfig.reloader)
end

function reloadConfig.start()
	reloadConfig.watcher:start()
end

function reloadConfig.stop()
	reloadConfig.watcher:stop()
end

reloadConfig.init()
reloadConfig.start()
