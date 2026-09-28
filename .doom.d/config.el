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

;; Enable editorconfig early, so the first file opened also gets it.
(editorconfig-mode 1)

;; Do not highlight the current line.
(remove-hook 'doom-first-input-hook #'global-hl-line-mode)

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

(defvar centaur-tabs-pressed nil
  "The tab under the last mouse press on the tab line.")

(defun centaur-tabs-press (event)
  "Remember the tab under the mouse press EVENT."
  (interactive "e")
  (setq centaur-tabs-pressed (centaur-tabs-get-tab-from-event event)))

(defun centaur-tabs-release (event)
  "Move the pressed tab to the tab under EVENT, or select that tab."
  (interactive "e")
  (let* ((from centaur-tabs-pressed)
         (end (posn-string (event-end event)))
         (to (and end (get-text-property (cdr end) 'centaur-tabs-tab (car end)))))
    (setq centaur-tabs-pressed nil)
    (if (not (and from to (not (equal from to))))
        (centaur-tabs-do-select event)
      (let* ((tabset (centaur-tabs-tab-tabset from))
             (tabs (centaur-tabs-tabs tabset))
             (i (cl-position to tabs :test #'equal))
             (rest (remove from tabs)))
        (set tabset (append (seq-take rest i) (list from) (seq-drop rest i)))
        (centaur-tabs-set-template tabset nil)
        (centaur-tabs-display-update)))))

;; Drag a tab to move it; compare tabs, as terminals send a click.
(after! centaur-tabs
  (define-key centaur-tabs-default-map [tab-line down-mouse-1] #'centaur-tabs-press)
  (define-key centaur-tabs-default-map [tab-line mouse-1] #'centaur-tabs-release)
  (define-key centaur-tabs-default-map [tab-line drag-mouse-1] #'centaur-tabs-release))

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

;; Use the mouse in terminals; Emacs 31 does not do it inside tmux.
(add-hook 'tty-setup-hook #'xterm-mouse-mode)

;; Configure mouse scrolling to be nicer.
(setq pixel-scroll-precision-mode t)
(setq pixel-scroll-precision-large-scroll-height 40.0)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 3))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

;; Make magit find my git repositories.
(setq magit-repository-directories '(("~/Source" . 3)))

;; Make projectile find my projects. Discovery is manual (SPC p D);
;; otherwise the first project-switching command of each session walks
;; the whole search path before showing anything.
(setq projectile-auto-discover nil)
(setq projectile-project-search-path
      '(("~/Documents/Rubin/Courses" . 1)
        ("~/Documents/Rubin/Exercism" . 2)
        ("~/Documents/Rubin/Notes" . 0)
        ("~/Documents/Rubin/Skills" . 0)
        ("~/Source" . 3)))

;; Hide menubar, toolbar and scrollbar by default.
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)

;; Set initial window size.
;; (when window-system (set-frame-size (selected-frame) 132 48))
(setq default-frame-alist '((width . 132) (height . 48)))

;; Set line spacing.
;;(when (string= (system-name) "FRAME")
(setq-default line-spacing 1)

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

;; Width of the float from K as a share of its window; a drag sets it.
(defvar lsp-doc-width 0.4)

;; Arguments of the last `lsp-ui-doc--render-buffer' call.
(defvar lsp-doc-last nil)

(defun lsp-doc-prepare (&rest args)
  "Remember ARGS and wrap the documentation to fit the float."
  (setq lsp-doc-last args
        lsp-ui-doc-max-width (round (* lsp-doc-width (window-body-width)))))

(defun lsp-doc-span (win)
  "Return the left and right pixel edges of WIN that the float may cover."
  (cons (car (window-inside-pixel-edges win))
        (- (nth 2 (window-pixel-edges win))
           (window-right-divider-width win)
           (window-scroll-bar-width win))))

(defun lsp-doc-place (&rest _)
  "Put the documentation float on the right side of its window."
  (when-let* ((frame (lsp-ui-doc--get-frame))
              (win (frame-parameter frame 'lsp-ui-doc--window-origin))
              ((window-live-p win)))
    (pcase-let* ((`(,left . ,right) (lsp-doc-span win))
                 (`(_ ,top _ ,bottom) (window-inside-pixel-edges win))
                 (width (round (* lsp-doc-width (- right left))))
                 ;; Border size; terminals do not draw internal borders.
                 (bw (- (frame-pixel-width frame) (frame-text-width frame)))
                 (bh (- (frame-pixel-height frame) (frame-text-height frame))))
      (modify-frame-parameters
       frame `((left . (+ ,(- right width)))
               (top . (+ ,top))
               (width . (text-pixels . ,(- width bw)))
               (height . (text-pixels . ,(- bottom top bh))))))))

(defun lsp-doc-reflow (frame)
  "Wrap and place the documentation float again after FRAME resizes."
  (when-let* ((doc (lsp-ui-doc--get-frame))
              ((frame-visible-p doc))
              (win (frame-parameter doc 'lsp-ui-doc--window-origin))
              ((window-live-p win)))
    ;; A resize of the float itself comes from a mouse drag.
    (when (eq frame doc)
      (let ((span (lsp-doc-span win)))
        (setq lsp-doc-width (/ (float (frame-pixel-width doc))
                               (- (cdr span) (car span))))))
    (with-selected-window win
      (apply #'lsp-ui-doc--render-buffer lsp-doc-last)
      (lsp-doc-place)
      (lsp-ui-doc--fix-hr-props))))

(defun lsp-doc-break-lines (width)
  "Break lines longer than WIDTH at word boundaries, except code."
  (save-excursion
    (goto-char (point-min))
    (while (not (eobp))
      (let ((bol (point))
            (eol (copy-marker (line-end-position))))
        (when (and (> (- eol bol) width) (not (lsp-doc-code-face-p bol)))
          ;; Indent the next lines under the text of a list item.
          (looking-at "[ \t]*\\([-*+]\\|[0-9]+[.)]\\)?[ \t]*")
          (let ((fill-column width)
                (fill-prefix (make-string (- (match-end 0) bol) ?\s)))
            (fill-region-as-paragraph bol eol)))
        (goto-char eol)
        (forward-line 1)))))

(defun lsp-doc-wrap (&rest _)
  "Wrap long lines in the documentation float at word boundaries."
  (let ((tty (not (display-graphic-p))))
    (with-current-buffer (lsp-ui-doc--make-buffer-name)
      (setq truncate-lines nil
            word-wrap t)
      (visual-wrap-prefix-mode 1)
      ;; Child frames in terminals do not show visual wrapping.
      (when tty
        (let ((inhibit-read-only t))
          (lsp-doc-break-lines (- lsp-ui-doc-max-width 2)))))))

(defun lsp-doc-code-face-p (pos)
  "Return non-nil if POS has the markdown code face."
  (memq 'markdown-code-face (ensure-list (get-text-property pos 'face))))

(defun lsp-doc-fill-code-gaps (&rest _)
  "Give empty lines inside code blocks the code background."
  (save-excursion
    (goto-char (point-min))
    (while (not (eobp))
      ;; lsp-ui-doc turns each empty line into a small " \n" line.
      (when (and (looking-at " \n")
                 (> (point) 1)
                 (lsp-doc-code-face-p (1- (point)))
                 (lsp-doc-code-face-p (+ (point) 2)))
        (add-face-text-property (point) (+ (point) 2) 'markdown-code-face t))
      (forward-line 1))))

(defun lsp-doc-drag-edge (event)
  "Resize the documentation float with a drag from its first column."
  (interactive "e")
  (let* ((doc (lsp-ui-doc--get-frame))
         (win (frame-parameter doc 'lsp-ui-doc--window-origin))
         (start (event-start event))
         (end (event-end event)))
    (if (not (zerop (car (posn-col-row start))))
        (mouse-set-region event)
      (pcase-let* ((`(,left . ,right) (lsp-doc-span win))
                   (endwin (posn-window end))
                   (x (+ (car (posn-x-y end))
                         (if (eq (window-frame endwin) doc)
                             (car (frame-position doc))
                           (car (window-inside-pixel-edges endwin))))))
        (setq lsp-doc-width
              (min 0.9 (max 0.1 (/ (float (- right x)) (- right left)))))
        (lsp-doc-reflow nil)))))

(defun lsp-doc-fix-hr-props ()
  "Draw rule lines so that nothing on their line wraps to a new row."
  (with-current-buffer (lsp-ui-doc--make-buffer-name)
    (let ((inhibit-read-only t)
          (pos (point-min)))
      (while (setq pos (text-property-any pos (point-max)
                                          'lsp-ui-doc--replace-hr t))
        (put-text-property pos (1+ pos) 'display
                           '(space :align-to (- right-fringe 1) :height (1)))
        (put-text-property (1+ pos) (save-excursion (goto-char pos)
                                                    (line-end-position))
                           'display '(space :width 0))
        (setq pos (1+ pos))))))

(defun lsp-doc-inline-p ()
  "Return non-nil when the documentation cannot use a child frame."
  (or (not lsp-ui-doc-use-childframe)
      (not (or (display-graphic-p) (featurep 'tty-child-frames)))))

(defun lsp-doc-setup-frame (frame _window)
  "Hide the border and window dividers of FRAME."
  (let ((bg (frame-parameter frame 'background-color)))
    (set-face-background 'internal-border bg frame)
    (set-face-background 'child-frame-border bg frame)
    (modify-frame-parameters frame '((right-divider-width . 0)
                                     (bottom-divider-width . 0)))))

;; Show docs from K in a full-height float on the right of the window.
(after! lsp-ui
  (advice-add 'lsp-ui-doc--render-buffer :before #'lsp-doc-prepare)
  (advice-add 'lsp-ui-doc--render-buffer :after #'lsp-doc-wrap)
  (advice-add 'lsp-ui-doc--move-frame :after #'lsp-doc-place)
  (advice-add 'lsp-ui-doc--inline-p :override #'lsp-doc-inline-p)
  ;; A wrapped rule line makes mouse wheel scrolling stop in the float.
  (advice-add 'lsp-ui-doc--fix-hr-props :override #'lsp-doc-fix-hr-props)
  ;; Terminals have no border to drag; drag the first column instead.
  (define-key lsp-ui-doc-frame-mode-map [drag-mouse-1] #'lsp-doc-drag-edge)
  ;; Its fill-region merges code lines when one line is too wide.
  (advice-add 'lsp-ui-doc--resize-buffer :override #'ignore)
  (advice-add 'lsp-ui-doc--make-smaller-empty-lines
              :after #'lsp-doc-fill-code-gaps)
  (add-hook 'window-size-change-functions #'lsp-doc-reflow)
  (add-hook 'lsp-ui-doc-frame-hook #'lsp-doc-setup-frame)
  ;; A wider border to grab; it has the background color.
  (setf (alist-get 'internal-border-width lsp-ui-doc-frame-parameters) 6)
  ;; A click must not take the keyboard; it stays there when hidden.
  (setf (alist-get 'no-accept-focus lsp-ui-doc-frame-parameters) t)
  (set-lookup-handlers! 'lsp-ui-mode
    :documentation '(lsp-ui-doc-show :async t)))

;; Completion docs show in the float from K, not in a corfu popup.
(remove-hook 'corfu-mode-hook #'corfu-popupinfo-mode)

;; Candidate whose docs are requested, and if the float shows them.
(defvar lsp-doc-candidate nil)
(defvar lsp-doc-completion-shown nil)

(defun lsp-doc-completion-string (item)
  "Render the docs of completion ITEM, with the signature on top if new."
  (let* ((detail (lsp:completion-item-detail? item))
         (docs (lsp:completion-item-documentation? item))
         (raw (if (stringp docs) docs (and docs (lsp:markup-content-value docs))))
         (text (lsp--render-element docs)))
    (if (and detail (not (string-search detail (or raw ""))))
        (concat (lsp--render-string detail (lsp-buffer-language)) "\n\n" text)
      text)))

(defun lsp-doc-completion-show (&rest _)
  "Show the docs of the selected LSP completion candidate in the float."
  (let ((cand (and (>= corfu--index 0) (nth corfu--index corfu--candidates)))
        (win (selected-window)))
    (unless (eq cand lsp-doc-candidate)
      (setq lsp-doc-candidate cand)
      (when (and cand (get-text-property 0 'lsp-completion-item cand))
        (lsp-completion--resolve-async
         cand
         (lambda (item)
           ;; Skip a reply for a candidate that is no longer selected.
           (when (and (eq cand lsp-doc-candidate) (window-live-p win))
             (with-selected-window win
               (let ((doc (lsp-doc-completion-string item)))
                 (unless (string-blank-p doc)
                   (lsp-ui-doc--display "" doc)
                   (setq lsp-doc-completion-shown t)))))))))))

(defun lsp-doc-completion-hide (&rest _)
  "Hide the float when it shows completion docs."
  (setq lsp-doc-candidate nil)
  (when lsp-doc-completion-shown
    (setq lsp-doc-completion-shown nil)
    (lsp-ui-doc--hide-frame)))

(after! corfu
  (advice-add 'corfu--exhibit :after #'lsp-doc-completion-show)
  (advice-add 'corfu--teardown :before #'lsp-doc-completion-hide))

(defun lsp-doc-diagnostic-string (err)
  "Render flycheck ERR as a header in its level color above its message."
  ;; lsp-mode's own levels use the fringe face of their base level.
  (let* ((face (flycheck-error-level-fringe-face (flycheck-error-level err)))
         (level (string-remove-prefix "flycheck-fringe-" (symbol-name face)))
         (head (mapconcat (lambda (part) (format "%s" part))
                          (delq nil (list (upcase level)
                                          (or (flycheck-error-group err)
                                              (flycheck-error-checker err))
                                          (flycheck-error-id err)))
                          " ")))
    ;; Without the blank line, the fill of the float can join the two.
    (concat (propertize head 'face face) "\n\n"
            (lsp--render-string (flycheck-error-message err) "markdown"))))

(defun lsp-doc-diagnostics ()
  "Show the diagnostics of the current line in the float from K."
  (interactive)
  (require 'lsp-ui)
  (let ((line (line-number-at-pos)))
    (if-let* ((errs (seq-filter (lambda (err) (eql (flycheck-error-line err) line))
                                (bound-and-true-p flycheck-current-errors))))
        (lsp-ui-doc--display
         "" (mapconcat #'lsp-doc-diagnostic-string errs "\n\n\n"))
      (message "No diagnostics"))))

;; No diagnostics beside code, in popups or on hover; C-w d shows them.
(remove-hook 'flycheck-mode-hook #'+syntax-init-popups-h)
(setq lsp-ui-sideline-show-diagnostics nil
      flycheck-help-echo-function nil)

;; Like Neovim; C-w c and SPC w d still delete the window.
(map! :n "C-w d"   #'lsp-doc-diagnostics
      :n "C-w C-d" #'lsp-doc-diagnostics)

;; Eldoc hides the error behind the LSP hover; the remap changes keys only.
(map! [remap flycheck-display-error-at-point] #'lsp-doc-diagnostics)

;; Configure lsp-modes.
(after! lsp-mode
  (setq lsp-enable-suggest-server-download nil)

  ;; The float shows the signature; in the menu it would cover the float.
  (setq lsp-completion-show-detail nil)

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

;; Font settings, sizes are updated by .profile.d/user-scaling.sh.
(setq doom-font (font-spec :family "Monospace" :size 14 :weight 'normal)
      doom-variable-pitch-font (font-spec :family "Sans" :size 14))

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

;; Git blame of the current line at its end, like current_line_blame.
(defface git-blame-line '((t :inherit shadow))
  "Face for the git blame of the current line.")

(defvar git-blame-line-delay 1.0
  "Seconds of idle time before the blame shows.")

(defvar git-blame-line--overlay nil)
(defvar git-blame-line--timer nil)
(defvar-local git-blame-line--user nil)

(defun git-blame-line--age (time)
  "Return how long ago TIME was, for example \"3 days ago\"."
  (let ((secs (- (float-time) time)))
    (cl-loop for (unit . size) in '(("year" . 31104000) ("month" . 2592000)
                                    ("day" . 86400) ("hour" . 3600)
                                    ("minute" . 60) ("second" . 1))
             for n = (floor secs size)
             when (or (>= n 1) (equal unit "second"))
             return (format "%d %s%s ago" n unit (if (> n 1) "s" "")))))

(defun git-blame-line--text (output)
  "Return the blame text for the porcelain OUTPUT of git blame."
  (let (fields)
    (dolist (line (split-string output "\n"))
      (when (string-match "\\`\\([a-z-]+\\) \\(.*\\)" line)
        (push (cons (match-string 1 line) (match-string 2 line)) fields)))
    (if (string-prefix-p "0000000000000000000000000000000000000000" output)
        " Not Committed Yet"
      (let ((author (alist-get "author" fields nil nil #'equal)))
        (format " %s, %s - %s "
                (if (equal author git-blame-line--user) "You" author)
                (git-blame-line--age
                 (string-to-number (alist-get "author-time" fields nil nil #'equal)))
                (alist-get "summary" fields nil nil #'equal))))))

(defun git-blame-line--clear ()
  "Remove the blame overlay."
  (when git-blame-line--overlay
    (delete-overlay git-blame-line--overlay)
    (setq git-blame-line--overlay nil)))

(defun git-blame-line--put (text)
  "Show TEXT at the end of the current line, cut to fit the window."
  (let* ((eol (line-end-position))
         (width (window-max-chars-per-line))
         (col (save-excursion (goto-char eol) (current-column)))
         (room (- width (% col width) 2)))
    (when (> room 0)
      (setq text (concat " " (truncate-string-to-width text room)))
      (put-text-property 0 1 'cursor t text)
      (setq git-blame-line--overlay (make-overlay eol eol))
      (overlay-put git-blame-line--overlay 'after-string
                   (propertize text 'face 'git-blame-line))
      (overlay-put git-blame-line--overlay 'tick
                   (buffer-chars-modified-tick)))))

(defun git-blame-line--show (buf)
  "Run git blame for the current line of BUF and show the result."
  (when (and (buffer-live-p buf) (eq buf (window-buffer)))
    (with-current-buffer buf
      (unless git-blame-line--user
        (setq git-blame-line--user
              (car (process-lines-ignore-status "git" "config" "user.name"))))
      (let* ((line (line-number-at-pos))
             (out (generate-new-buffer " *git-blame-line*"))
             (proc (make-process
                    :name "git-blame-line" :buffer out :noquery t
                    :connection-type 'pipe
                    :command (list "git" "blame" "--porcelain"
                                   "-L" (format "%d,%d" line line)
                                   "--contents" "-" "--" buffer-file-name)
                    :sentinel
                    (lambda (proc _)
                      (unless (process-live-p proc)
                        (let ((output (with-current-buffer out (buffer-string))))
                          (kill-buffer out)
                          (when (and (zerop (process-exit-status proc))
                                     (buffer-live-p buf))
                            (with-current-buffer buf
                              (when (= line (line-number-at-pos))
                                (git-blame-line--clear)
                                (git-blame-line--put
                                 (git-blame-line--text output)))))))))))
        (process-send-region proc (point-min) (point-max))
        (process-send-eof proc)))))

(defun git-blame-line--update ()
  "Hide the blame when the line changes and show it again when idle."
  (let ((ov git-blame-line--overlay))
    (unless (and ov
                 (eq (overlay-buffer ov) (current-buffer))
                 (= (overlay-start ov) (line-end-position))
                 (= (overlay-get ov 'tick) (buffer-chars-modified-tick)))
      (git-blame-line--clear)
      (when git-blame-line--timer
        (cancel-timer git-blame-line--timer))
      (when (and buffer-file-name (not (file-remote-p buffer-file-name)))
        (setq git-blame-line--timer
              (run-with-idle-timer git-blame-line-delay nil
                                   #'git-blame-line--show
                                   (current-buffer)))))))

(define-minor-mode git-blame-line-mode
  "Show the git blame of the current line at the end of the line."
  :global t
  (if git-blame-line-mode
      (add-hook 'post-command-hook #'git-blame-line--update)
    (remove-hook 'post-command-hook #'git-blame-line--update)
    (git-blame-line--clear)))

(git-blame-line-mode 1)

(map! :leader
      :desc "Git blame line" "t b" #'git-blame-line-mode
      :desc "Big mode"       "t B" #'doom-big-font-mode)

;; Enable emacs MCP server.
(use-package! mcp-server
  :config
  (setq mcp-server-socket-name nil)
  (add-hook 'emacs-startup-hook #'mcp-server-start-unix)
  (add-hook 'kill-emacs-hook (lambda () (ignore-errors (mcp-server-stop))))
  (advice-add 'mcp-server-start-unix :after
              (lambda (&rest _)
                (let ((proc (get-process "emacs-mcp-unix-server")))
                  (when proc
                    (set-process-query-on-exit-flag proc nil))))))

;; Enable interactive prompting for permissions.
(setq mcp-server-security-prompt-for-permissions t)

;; Allow MCP access to *Messages*, shells and compilation output.
(setq mcp-server-security-sensitive-buffer-patterns nil)

;; Answering "!" in an MCP prompt allows all operations this session.
(defvar +mcp-allow-all nil)
(defadvice! +mcp-allow-all-a (fn op &optional data)
  :around #'mcp-server-security-check-permission
  (or +mcp-allow-all
      (prog1 (funcall fn op data)
        (when (gethash (format "%s:%s" op data)
                       mcp-server-security--permission-cache)
          (setq +mcp-allow-all t)))))

;; Show emacs version after startup.
;;(add-hook 'window-setup-hook (lambda () (run-with-timer 1.2 nil #'call-interactively 'version)))

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
