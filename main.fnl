(hs.ipc.cliInstall)

(local fennel (require :fennel))
(local log (hs.logger.new "main.fnl"))
(log.i "Loading Alakazam!🥄")

(local reloadConfig (require "reloadConfig")) ;; TODO rewrite in Fennel

(local utils (require "utils")) ;; TODO rewrite in Fennel
(local bk utils.bk)

(fn join [...]
  "Join tables into new table"
  (let [new {}]    
    (each [_ v (ipairs [...])]
      (tset new v v))
    new))

;; Set global screen names
(global laptopScreen (hs.screen.find "Built%-in Retina Display"))
(global middleScreen (hs.screen.find "LG HDR 4K"))
(global portraitScreen (hs.screen.find "DELL P2414H"))

;; Set global mod-keys
(global ctrl [:ctrl])
(global meta [:alt])
(global cmd [:cmd])
(global shift [:shift])
(global meh [:ctrl :alt :shift])
(global super [:ctrl :alt :cmd])
(global hyper [:ctrl :alt :cmd :shift])

(bk hyper "d" "Toggle: Dark mode" (utils.applescript "toggle-dark-mode"))

(local metaX (require "meta-x")) ;; TODO rewrite in Fennel
(metaX.init meta ctrl (utils.applescript "raycast/open"))

(local hlWin (require "highlightWindow")) ;; TODO rewrite in Fennel
(hlWin:start)

(require "apps") ;; TODO rewrite in Fennel

(local spoonManager (require "spoonManager")) ;; TODO rewrite in Fennel
(spoonManager:init log reloadConfig)
(spoonManager.installMaybe [{:name :SpoonInstall
                             :uri "https://github.com/Hammerspoon/Spoons/raw/master/Spoons/SpoonInstall.spoon.zip"}])


(global spoon (or _G.spoon {}))
(hs.loadSpoon :SpoonInstall)
(set spoon.SpoonInstall.use_syncinstall true)
(global Install spoon.SpoonInstall)

(Install:andUse :ColorPicker {:config {:show_in_menubar false}
                              :hotkeys {:show [hyper :c]}
                              :start true})

(Install:andUse :ClipboardTool {:config {:pase_on_select true
                                         :show_copied_alert false
                                         :show_in_menubar false}
                                :hotkeys {:toggle_clipboard [hyper :v]}
                                :start true})	
