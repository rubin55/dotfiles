;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Disable bold fonts.
(defun remap-faces-default-attributes ()
  (let ((family (face-attribute 'default :family))
        (height (face-attribute 'default :height)))
    (mapcar (lambda (face)
              (face-remap-add-relative
               face :family family :weight 'normal :height height))
            (face-list))))

(when (display-graphic-p)
  (add-hook 'minibuffer-setup-hook 'remap-faces-default-attributes)
  (add-hook 'change-major-mode-after-body-hook 'remap-faces-default-attributes))

;; Make yank go to clipboard primary.
(setq select-enable-primary t)

;; Default indent length.
(setq standard-indent 2)

;; Make treemacs not use variable width fonts.
(setq doom-themes-treemacs-enable-variable-pitch nil)

;; Scale treemacs icons to something that looks appealing.
;;(treemacs-resize-icons 16)

;; Make treemacs not use png icons in gui mode.
;;(setq treemacs-no-png-images t)


;; Try to avoid emacs window chaos. If this is a step too far, then replace
;; display-buffer-same-window with display-buffer-pop-up-window.
(customize-set-variable 'display-buffer-base-action
                        '((display-buffer-reuse-window display-buffer-same-window)
                          (reusable-frames . t)))

(customize-set-variable 'even-window-sizes nil)

;; Group tabs by (projectile) project, and active tab
;; is shown with a colored line on top.
(with-eval-after-load 'centaur-tabs
  (centaur-tabs-group-by-projectile-project)
  (setq centaur-tabs-set-bar 'over))

;; Be able to switch buffers by clicking on their tab.
(setq mouse-1-click-follows-link -450)

;; Configure mouse scrolling to be nicer.
(setq pixel-scroll-precision-mode t)
(setq pixel-scroll-precision-large-scroll-height 40.0)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

;; Make magit find my git repositories.
(setq magit-repository-directories '(("~/Source" . 3)))

;; Make projectile find my projects.
(setq projectile-project-search-path '(("~/Source" . 3) ("~/Documents/Rubin/Courses/Exercism" . 2)))

;; Hide menubar, toolbar and scrollbar by default.
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)

;; Set initial window size.
;; (when window-system (set-frame-size (selected-frame) 132 48))
(setq default-frame-alist '((width . 132) (height . 48)))

;; Set line spacing.
(when (string= (system-name) "FRAME")
  (setq-default line-spacing 1))

;; Enable long line wrap by default.
(global-visual-line-mode 1)
(setq-default word-wrap t)

;; Configure nov.el epub mode.
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
(setq nov-text-width t)
(setq visual-fill-column-center-text t)
(add-hook 'nov-mode-hook 'visual-line-mode)
(add-hook 'nov-mode-hook 'visual-fill-column-mode)
(add-hook 'nov-mode-hook 'adaptive-wrap-prefix-mode)

;; Configure pdf-tools mode.
(add-hook 'pdf-misc-minor-mode-hook 'pdf-view-midnight-minor-mode)

;; Always enable server mode, for emacsclient sessions.
(server-start)

;; Configure lsp python mode explicitly.
;; Not required for python-language-server.
;; (use-package lsp-pyright
;;   :hook (python-mode . (lambda ()
;;                          (require 'lsp-pyright)
;;                          (lsp))))

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
  :hook ((java-mode . lsp))
  :config
  (setq lsp-java-server-install-dir "/usr/share/java/jdtls"))

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
  (setq lsp-groovy-server-file "/usr/share/java/groovy-language-server/groovy-language-server-all.jar"))

;; Configure lsp lua mode.
(use-package lsp-mode
  :hook ((lua-mode . lsp))
  :config
  (setq lsp-clients-lua-language-server-install-dir "/usr/lib/lua-language-server/")
  (setq lsp-clients-lua-language-server-bin "/usr/lib/lua-language-server/bin/lua-language-server"))

;; Configure lsp json mode.
(use-package lsp-mode
  :hook ((json-mode . lsp)))

;; Configure lsp powershell mode.
(use-package lsp-mode
  :hook ((powershell-mode . lsp))
  :config
  (setq lsp-pwsh-exe "/usr/bin/pwsh"))

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
  (setq lsp-xml-server-command "/usr/bin/lemminx"))

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
         (erlang-edoc-mode . lsp)))

;; Configure lsp elixir mode.
(use-package lsp-mode
  :hook ((elixir-mode . lsp)
         (alchemist-mode . lsp))
  :init (add-to-list 'exec-path "/usr/lib/elixir-ls"))

;; Enable lsp logging.
(setq lsp-log-io t)

;; Configure flycheck markdown mode.
(setq flycheck-markdown-markdownlint-cli-config "~/.markdownlintrc")

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Rubin Simons'"
      user-mail-address "me@rubin55.org")

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

;; Font settings for FRAME, my Linux laptop.
(when (string= (system-name) "FRAME")
  (setq doom-font (font-spec :family "Monospace" :size 15 :weight 'normal)
        doom-variable-pitch-font (font-spec :family "Sans" :size 15)))

;; Font settings for THINK, my other Linux laptop.
(when (string= (system-name) "THINK")
  (setq doom-font (font-spec :family "Monospace" :size 16 :weight 'normal)
        doom-variable-pitch-font (font-spec :family "Sans" :size 16)))

;; Font settings for GEMINI, my Linux desktop at work.
(when (string= (system-name) "GEMINI")
  (setq doom-font (font-spec :family "Monospace" :size 18 :weight 'normal)
        doom-variable-pitch-font (font-spec :family "Sans" :size 18)))

;; Font settings for TAURUS, my Linux desktop at home.
(when (string= (system-name) "TAURUS")
  (setq doom-font (font-spec :family "Monospace" :size 16 :weight 'normal)
        doom-variable-pitch-font (font-spec :family "Sans" :size 16)))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-tomorrow-day)
;;(setq doom-theme 'doom-laserwave)
;;(setq doom-theme 'doom-rose-pine)
(setq doom-theme 'doom-wilmersdorf)

;; Disable bold, enable italic.
(after! doom-themes
  (setq doom-themes-enable-bold nil
        doom-themes-enable-italic t))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/.org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Don't auto-close vterms when they're not visible, and always open a vterm
;; buffer in the current window.
(after! vterm
  (setq vterm-toggle-reset-window-configration-after-exit 'kill-window-only)
  (setq vterm-toggle-hide-method nil)
  (setq vterm-toggle-fullscreen-p nil)
  (add-to-list 'display-buffer-alist
               '((lambda (buffer-or-name _)
                   (let ((buffer (get-buffer buffer-or-name)))
                     (with-current-buffer buffer
                       (or (equal major-mode 'vterm-mode)
                           (string-prefix-p vterm-buffer-name (buffer-name buffer))))))
                 (display-buffer-reuse-window display-buffer-same-window))))

;; Disable insane 'jk' to-command-mode sequence.
(after! evil-escape
  (setq evil-escape-key-sequence nil))

;; Enable lsp-ui-doc.
(after! lsp-ui
  (setq lsp-ui-doc-enable t))

;; Show emacs version after startup.
(add-hook 'window-setup-hook (lambda () (run-with-timer 1.2 nil #'call-interactively 'version)))

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
