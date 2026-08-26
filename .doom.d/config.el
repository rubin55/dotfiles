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

;; Make projectile find my projects. Discovery is manual (SPC p D);
;; otherwise the first project-switching command of each session walks
;; the whole search path before showing anything.
(setq projectile-project-search-path '(("~/Source" . 3) ("~/Documents/Rubin/Exercism" . 2) ("~/Documents/Rubin/Courses" . 1)))
(setq projectile-auto-discover nil)

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

;; lang/web claims .svelte for web-mode; give it a mode of its own.
(add-to-list 'auto-mode-alist '("\\.svelte\\'" . svelte-mode))

;; astro-ts-mode ships no usable autoloads (see packages.el) and errors
;; if any of its grammars are missing.
(autoload 'astro-ts-mode "astro-ts-mode" "Major mode for Astro templates." t)

;; The package only registers this recipe once it loads, which is too late
;; to install from. The css and typescript recipes come from lang/web and
;; lang/javascript. Kept in sync with the pinned astro-ts-mode.
(after! treesit
  (add-to-list 'treesit-language-source-alist
               '(astro "https://github.com/virchau13/tree-sitter-astro"
                       :commit "213f6e6973d9b456c6e50e86f19f66877e7ef0ee")))

(defun +astro-ts-mode ()
  "Enable `astro-ts-mode', installing its grammars first if needed."
  (interactive)
  (require 'treesit)
  (dolist (lang '(astro html css typescript))
    (unless (treesit-ready-p lang t)
      (treesit-ensure-installed lang)))
  (astro-ts-mode))

(add-to-list 'auto-mode-alist '("\\.astro\\'" . +astro-ts-mode))

;; No :lang module covers these, so nothing would start a server for them
;; the way the +lsp flags do elsewhere.
(add-hook 'astro-ts-mode-local-vars-hook #'lsp! 'append)
(add-hook 'svelte-mode-local-vars-hook #'lsp! 'append)
(add-hook 'powershell-mode-local-vars-hook #'lsp! 'append)

;; Configure lsp-modes.
(after! lsp-mode
  (setq lsp-enable-suggest-server-download nil)

  (setq lsp-xml-prefer-jar nil
        lsp-xml-bin-file "/usr/bin/lemminx")

  (setq lsp-xml-file-associations
        [(:systemId "https://maven.apache.org/xsd/maven-4.0.0.xsd"
                    :pattern "**/*.pom")])

  (setq lsp-fsharp-auto-workspace-init t)

  (setq lsp-pwsh-dir "/usr/share/powershell/Modules"
        lsp-pwsh-pses-script
        (concat lsp-pwsh-dir "/PowerShellEditorServices/Start-EditorServices.ps1")
        lsp-pwsh-log-path
        (expand-file-name "lsp-pwsh" temporary-file-directory))

  (make-directory lsp-pwsh-log-path t)

  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection '("kotlin-lsp" "--stdio"))
    :major-modes '(kotlin-mode kotlin-ts-mode)
    :priority 1
    :server-id 'kotlin-lsp))

  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection
                     '("roslyn-language-server" "--stdio" "--autoLoadProjects"
                       "--logLevel" "Information"))
    :major-modes '(csharp-mode csharp-ts-mode)
    :priority 1
    :server-id 'roslyn-ls))

  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection '("expert" "--stdio"))
    :major-modes '(elixir-mode elixir-ts-mode heex-ts-mode)
    :priority 1
    :server-id 'expert-ls)))

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
  (setq doom-font (font-spec :family "Monospace" :size 14 :weight 'normal)
        doom-variable-pitch-font (font-spec :family "Sans" :size 14)))

;; Font settings for GEMINI, my Linux desktop at work.
(when (string= (system-name) "GEMINI")
  (setq doom-font (font-spec :family "Monospace" :size 14 :weight 'normal)
        doom-variable-pitch-font (font-spec :family "Sans" :size 14)))

;; Font settings for TAURUS, my Linux desktop at home.
(when (string= (system-name) "TAURUS")
  (setq doom-font (font-spec :family "Monospace" :size 18 :weight 'normal)
        doom-variable-pitch-font (font-spec :family "Sans" :size 18)))

;; Configure doom theme through auto-dark.
(use-package! auto-dark
  :hook (doom-init-ui . auto-dark-mode)
  :config
  (setq custom-safe-themes t)
  (setq auto-dark-themes '((doom-dracula) (doom-rose-pine-dawn))))

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
