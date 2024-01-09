(hs.ipc.cliInstall)

(local fennel (require :fennel))
(local log (hs.logger.new "main.fnl"))
(log.i "Loading Alakazam!🥄")

(require "reloadConfig") -- TODO rewrite in Fennel

(local utils (require "utils")) -- TODO rewrite in Fennel
(local bk utils.bk)

