;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Private config; changes here do not need 'doom sync'.
;; Configuration of a package is in after/NAME.el; see the end.

;; Make yank go to clipboard primary.
(setq select-enable-primary t)

;; Default indent length.
(setq standard-indent 2)

;; Enable editorconfig early, so the first file opened also gets it.
(editorconfig-mode 1)

;; Do not highlight the current line.
(remove-hook 'doom-first-input-hook #'global-hl-line-mode)

(defun +treemacs-toggle ()
  "Toggle treemacs; first sync the projects of the workspace.
Doom's toggle removes all projects but the current one."
  (interactive)
  (require 'treemacs)
  (unless (eq (treemacs-current-visibility) 'visible)
    (+treemacs-sync-workspace-h))
  (treemacs))

(map! :leader :desc "Project sidebar" "o p" #'+treemacs-toggle)

;; Reuse windows; use display-buffer-pop-up-window if this is too much.
(customize-set-variable 'display-buffer-base-action
                        '((display-buffer-reuse-window display-buffer-same-window)
                          (reusable-frames . t)))

;; Keep my split sizes when a buffer shows in the other window.
(customize-set-variable 'even-window-sizes nil)

;; Drag the right fringe to resize a window; the divider is only 1px.
(map! [right-fringe down-mouse-1] #'mouse-drag-vertical-line)

;; Wider window divider to grab with the mouse; it shows a 1px line.
(setq window-divider-default-right-width 6)

(defun divider-hide-padding-h ()
  "Draw all but the last pixel of the window divider in the background."
  (let ((bg (face-background (if (facep 'solaire-default-face)
                                 'solaire-default-face
                               'default)
                             nil t)))
    (set-face-foreground 'window-divider-last-pixel
                         (face-foreground 'vertical-border nil t))
    (set-face-foreground 'window-divider bg)
    (set-face-foreground 'window-divider-first-pixel bg)))

(add-hook 'doom-load-theme-hook #'divider-hide-padding-h)

;; Disable bold; doom-themes-enable-bold only covers theme faces.
(defun +unbold-face (face &rest _)
  "Give FACE the normal weight if it is heavier than medium."
  (let ((weight (face-attribute face :weight)))
    (when (seq-some (lambda (entry)
                      (and (> (aref entry 0) 100)
                           (memq weight (append entry nil))))
                    font-weight-table)
      (set-face-attribute face nil :weight 'normal))))

(defun +unbold-faces-h ()
  "Give all faces that are heavier than medium the normal weight."
  (mapc #'+unbold-face (face-list)))

(add-hook 'doom-load-theme-hook #'+unbold-faces-h)

;; Also unbold the faces of packages that load after the theme.
(advice-add 'custom-declare-face :after #'+unbold-face)

;; Use the mouse in terminals; Emacs 31 does not do it inside tmux.
(add-hook 'tty-setup-hook #'xterm-mouse-mode)

;; Scroll 4 lines per wheel step, 8 with shift, without acceleration.
(setq mouse-wheel-scroll-amount '(4 ((shift) . 8)))
(setq mouse-wheel-progressive-speed nil)

;; Make projectile, magit and treemacs find my projects.
(setq projectile-project-search-path
      '(("~/Documents/Rubin/Courses" . 1)
        ("~/Documents/Rubin/Exercism" . 2)
        ("~/Documents/Rubin/Notes" . 0)
        ("~/Documents/Rubin/Skills" . 0)
        ("~/Source" . 3)))
(setq magit-repository-directories projectile-project-search-path)

;; Set the frame size; keep Doom's entries, which hide the scroll bar.
(add-to-list 'default-frame-alist '(width . 132))
(add-to-list 'default-frame-alist '(height . 48))

;; Enable long line wrap by default.
(global-visual-line-mode 1)

;; Open epub files with nov.el.
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

;; Always enable server mode, for emacsclient sessions.
(server-start)

;; lang/web claims .svelte for web-mode; give it a mode of its own.
(add-to-list 'auto-mode-alist '("\\.svelte\\'" . svelte-mode))

;; astro-ts-mode has no usable autoloads (see packages.el).
(autoload 'astro-ts-mode "astro-ts-mode" "Major mode for Astro templates." t)

(defun +astro-ts-mode ()
  "Enable `astro-ts-mode', installing its grammars first if needed."
  (interactive)
  (require 'treesit)
  (dolist (lang '(astro html css typescript))
    (unless (treesit-ready-p lang t)
      (treesit-ensure-installed lang)))
  (astro-ts-mode))

(add-to-list 'auto-mode-alist '("\\.astro\\'" . +astro-ts-mode))

;; Docs, diagnostics and completion docs from LSP in a float.
(load! "lisp/lsp-hover")

;; Like Neovim; C-w c and SPC w d still delete the window.
(map! :n "C-w d"   #'lsp-hover-diagnostics
      :n "C-w C-d" #'lsp-hover-diagnostics)

;; Eldoc hides the error behind the LSP hover; the remap changes keys only.
(map! [remap flycheck-display-error-at-point] #'lsp-hover-diagnostics)

;; Identify me to GPG, email clients, file templates and snippets.
(setq user-full-name "Rubin Simons"
      user-mail-address "me@rubin55.org")

;; Font settings, sizes are updated by .profile.d/user-scaling.sh.
(setq doom-font (font-spec :family "PragmataPro" :size 15 :weight 'normal)
      doom-symbol-font (font-spec :family "PragmataPro")
      doom-variable-pitch-font (font-spec :family "Ubuntu" :size 16))

;; Switch between the dark and light theme with the system.
(add-hook 'doom-init-ui-hook #'auto-dark-mode)

;; Set `org-directory' before org loads.
(setq org-directory "~/.org/")

;; Git blame of the current line at its end.
(load! "lisp/git-blame")
(git-blame-line-mode 1)

(map! :leader
      :desc "Git blame line" "t b" #'git-blame-line-mode
      :desc "Big mode"       "t B" #'doom-big-font-mode)

(map! :leader
      :desc "List bookmarks" "b L" #'bookmark-bmenu-list)

;; Start the Emacs MCP server.
(add-hook 'emacs-startup-hook #'mcp-server-start-unix)

;; Load after/NAME.el when the feature NAME loads.
(dolist (file (directory-files (file-name-concat doom-user-dir "after")
                               t "\\.el\\'"))
  (with-eval-after-load (intern (file-name-base file))
    (load file nil t)))
