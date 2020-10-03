;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Be silent about cl package being deprecated.
(setq byte-compile-warnings '(cl-functions))

;; Always enable server mode, for emacsclient sessions.
(server-start)

;; Configure lsp python mode.
(use-package lsp-pyright
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))

;; Configure lsp c mode.
(use-package ccls
  :hook ((c-mode c++-mode objc-mode cuda-mode) . (lambda ()
                                                   (require 'ccls)
                                                   (lsp))))
;; Configure lsp clojure mode.
(use-package lsp-mode
  :hook ((clojure-mode . lsp)
         (clojurec-mode . lsp)
         (clojurescript-mode . lsp)))

;; Configure lsp javascript and typescript modes.
(use-package lsp-mode
  :hook ((javascript-mode . lsp)
         (js2-mode . lsp)
         (js2-jsx-mode . lsp)
         (typescript-mode . lsp)
         (typescript-tsx-mode . lsp)))

;; Configure lsp go mode.
(use-package lsp-mode
  :hook ((go-mode . lsp)
         (go-dot-mod-mode . lsp)))

;; Configure lsp haskell mode.
(use-package lsp-haskell
  :hook ((haskell-mode . lsp))
 :config
 (setq lsp-haskell-process-path-hie "haskell-language-server")
 ;; Comment/uncomment this line to see interactions between lsp client/server.
 ;;(setq lsp-log-io t)
)

;; Configure lsp ruby mode.
(use-package lsp-mode
  :hook ((ruby-mode . lsp)))

;; Configure lsp scala mode.
(use-package lsp-mode
  :hook ((scala-mode . lsp)))

;; Configure lsp java mode.
(use-package lsp-mode
  :hook ((java-mode . lsp)))

;; Configure lsp csharp mode.
(use-package lsp-mode
  :hook ((csharp-mode . lsp)))

;; Configure lsp cmake mode.
(use-package lsp-mode
  :hook ((cmake-mode . lsp)))

;; Configure lsp css mode.
(use-package lsp-mode
  :hook ((css-mode . lsp)
         (less-css-mode . lsp)
         (sass-mode . lsp)
         (scss-mode . lsp)))

;; Configure lsp docker mode.
(use-package lsp-mode
  :hook ((dockerfile-mode . lsp)))

;; Configure lsp groovy mode.
(use-package lsp-mode
  :hook ((groovy-mode . lsp)
         (groovy-electric-mode . lsp))
 :config
 (setq lsp-groovy-server-file "~/.emacs.d/.local/etc/lsp/groovy-language-server/build/libs/groovy-language-server-all.jar"))

;; Configure lsp lua mode.
(use-package lsp-mode
  :hook ((lua-mode . lsp))
 :config
 (setq lsp-clients-lua-language-server-install-dir "~/.emacs.d/.local/etc/lsp/lua-language-server")
 (setq lsp-clients-lua-language-server-bin "~/.emacs.d/.local/etc/lsp/lua-language-server/bin/Linux/lua-language-server"))

;; Configure lsp json mode.
(use-package lsp-mode
  :hook ((json-mode . lsp)))

;; Configure lsp powershell mode.
(use-package lsp-mode
  :hook ((powershell-mode . lsp))
 :config
 (setq lsp-pwsh-exe "/opt/powershell/ps7/pwsh"))

;; Configure lsp html mode.
(use-package lsp-mode
  :hook ((html-mode . lsp)))

;; Configure lsp yaml mode.
(use-package lsp-mode
  :hook ((yaml-mode . lsp)))

;; Configure lsp xml mode.
(use-package lsp-mode
  :hook ((xml-mode . lsp)
         (nxml-mode . lsp))
 :config
 (setq lsp-xml-server-command "xml-ls.sh")
 (setq lsp-xml-server-vmargs "-noverify -Xmx64M -XX:+UseG1GC -XX:+UseStringDeduplication -jar")
 (setq lsp-xml-jar-file "/home/rubin/.emacs.d/.local/etc/lsp/lemminx/org.eclipse.lemminx/target/org.eclipse.lemminx-uber.jar"))

;; Configure lsp sql mode.
(use-package lsp-mode
  :hook ((sql-mode . lsp)))

;; Configure lsp (la)tex mode.
(use-package lsp-mode
  :hook ((tex-mode . lsp)
         (latex-mode . lsp)))

;; Configure lsp erlang mode.
(use-package lsp-mode
  :hook ((erlang-mode . lsp)
         (erlang-edoc-mode . lsp))
 :config
 (setq lsp-erlang-server-connection-type "stdio")
 (setq lsp-erlang-server-path "~/.emacs.d/.local/etc/lsp/erlang_ls/_build/default/bin/erlang_ls"))

;; Configure lsp elixir mode.
(use-package lsp-mode
  :hook ((elixir-mode . lsp)
         (alchemist-mode . lsp))
 :config
 (setq lsp-clients-elixir-server-executable "~/.emacs.d/.local/etc/lsp/elixir-ls/_build/default/language_server.sh"))

;; Enable lsp logging.
(setq lsp-log-io t)

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Rubin Simons'"
      user-mail-address "rubin@xs4all.nl")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
(setq doom-font (font-spec :family "monospace" :size 17 :weight 'normal)
      doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/.org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
