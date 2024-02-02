-- Add Luarocks to package paths so we can load Fennel
package.path =
   package.path
   .. ";"
   .. os.getenv("HOME")
   .. "/.luarocks/share/lua/5.4/?.lua;"
   .. os.getenv("HOME")
   .. "/.luarocks/share/lua/5.4/?/init.lua"
package.cpath =
   package.cpath
   .. ";"
   .. os.getenv("HOME")
   .. "/.luarocks/lib/lua/5.4/?.so"
package.path =
   package.path
   .. ";"
   .. os.getenv("HOME")
   .. "/.luarocks/share/lua/5.3/?.lua;"
   .. os.getenv("HOME")
   .. "/.luarocks/share/lua/5.3/?/init.lua"
package.cpath =
   package.cpath
   .. ";"
   .. os.getenv("HOME")
   .. "/.luarocks/lib/lua/5.3/?.so"

fennel = require("fennel")
table.insert(package.loaders or package.searchers, fennel.searcher)

require("main")

