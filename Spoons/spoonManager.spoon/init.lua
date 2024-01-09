spoonManager = {
log = {},
reloadConfig = {},
}

-- Execute a command and return its output with trailing EOLs trimmed. If the command fails, an error message is logged.
function spoonManager:x(cmd, errfmt, ...)
	local output, status = hs.execute(cmd)
	if status then
		local trimstr = string.gsub(output, "\n*$", "")
		return trimstr
	else
		return nil
	end
end

function spoonManager:_installSpoonFromZipURL(urlparts, status, body, headers)
	local success = nil
	if (status < 100) or (status >= 400) then
		self.log.e("Error downloading %s. Error code %d: %s", urlparts.absoluteString, status, body or "<none>")
	else
		-- Write the zip file to disk in a temporary directory
		local tmpdir = spoonManager:x("/usr/bin/mktemp -d", "Error creating temporary directory to download new spoon.")
		if tmpdir then
			local outfile = string.format("%s/%s", tmpdir, urlparts.lastPathComponent)
			local f = assert(io.open(outfile, "w"))
			f:write(body)
			f:close()

			-- Check its contents - only one *.spoon directory should be in there
			output = spoonManager:x(
				string.format(
					"/usr/bin/unzip -l %s '*.spoon/' | /usr/bin/awk '$NF ~ /\\.spoon\\/$/ { print $NF }' | /usr/bin/wc -l",
					outfile
				),
				"Error examining downloaded zip file %s, leaving it in place for your examination.",
				outfile
			)
			if output then
				if (tonumber(output) or 0) == 1 then
					-- Uncompress the zip file
					local outdir = string.format("%s/Spoons", hs.configdir)
					if
						spoonManager:x(
							string.format("/usr/bin/unzip -o %s -d %s 2>&1", outfile, outdir),
							"Error uncompressing file %s, leaving it in place for your examination.",
							outfile
						)
					then
						-- And finally, install it using Hammerspoon itself
						self.log.i("Downloaded and installed %s", urlparts.absoluteString)
						spoonManager:x(string.format("/bin/rm -rf '%s'", tmpdir), "Error removing directory %s", tmpdir)
						success = true
					end
				else
					self.log.e(
						"The downloaded zip file %s is invalid - it should contain exactly one spoon. Leaving it in place for your examination.",
						outfile
					)
				end
			end
		end
	end
	return success
end

function spoonManager:installSpoonFromZipURL(url)
	local urlparts = hs.http.urlParts(url)
	local dlfile = urlparts.lastPathComponent
	if dlfile and dlfile ~= "" and urlparts.pathExtension == "zip" then
		a, b, c = hs.http.get(url)
		return spoonManager._installSpoonFromZipURL(urlparts, a, b, c)
	else
		self.log.e("Invalid URL %s, must point to a zip file", url)
		return nil
	end
end

function spoonManager:installZip(spoon)
	spoonManager:installSpoonFromZipURL(spoon.uri)
end

function spoonManager:installGit(spoon)
	gitCloneTask = hs.task.new("/usr/bin/git", function(a, b, c)
		return
	end, { "clone", spoon.uri, spoon.path })
	gitCloneTask:waitUntilExit()
	gitCloneTask:start()
end

function spoonManager:install(spoon)
	ext = string.sub(spoon.uri, -4)
	pcall(function() self.reloadConfig.stop() end)
	if ext == ".git" then
		spoonManager:installGit(spoon)
	end
	if ext == ".zip" then
		spoonManager:installZip(spoon)
	else
		self.log.e("Unknown file type, not installing " .. spoon.name)
	end
	pcall(function() self.reloadConfig.start() end)
end

function spoonManager:installMaybe(spoonList)
	if spoonList == nil then
		return
	end
	for _, spoon in pairs(spoonList) do
		install_path = "Spoons/" .. spoon.name .. ".spoon"
		installed = nil
		if spoon.path then
			install_path = spoon.path
			installed, _ = hs.fs.mkdir(spoon.path)
			installed = not installed
			if not installed then
				hs.fs.rmdir(spoon.path)
			end
		else
			installed = hs.spoons.isInstalled(spoon.name)
		end
		spoon.path = install_path
		if not installed then
			self.log.i("Installing " .. spoon.name .. " from uri: " .. spoon.uri)
			hs.alert("Install " .. spoon.name .. ". This will just take a moment!")
			spoonManager.install(spoon)
		else
			self.log.e(spoon.name .. " already installed!")
		end
	end
end

function spoonManager:init(logger, reloadConfig)
    self.logger = logger or {}
    self.reloadConfig = reloadConfig or {}
end

return spoonManager
