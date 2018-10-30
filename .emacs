;; Always enable server mode, for emacsclient sessions.
(server-start)

;; Ensure UTF-8 mode.
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;; Enable Font Ligatures when we can.
(if (fboundp 'mac-auto-operator-composition-mode)
    (mac-auto-operator-composition-mode))

;; Rebind middle-mouse-button.
(define-key key-translation-map (kbd "<s-mouse-1>") (kbd "<mouse-2>"))

;; Remember file positions.
(save-place-mode 1)

;; Configure tab behaviour.
(setq-default tab-width 4 indent-tabs-mode nil)
(setq-default c-basic-offset 4 c-default-style "bsd")

;; Create a tab mode toggle function and assign to F7.
(defun toggle-tab-mode-setting ()
    "Toggle setting tab mode between tab and spaces"
    (interactive)
    (setq indent-tabs-mode (not indent-tabs-mode)))
(global-set-key (kbd "<f7>") 'toggle-tab-mode-setting)

;; Create a tab size toggle function and assign to F8.
(defun toggle-tab-size-setting ()
    "Toggle setting tab sizes between 4, 8, 16 and 32"
    (interactive)
    (setq tab-width (if (= tab-width 32) 16 (if (= tab-width 16) 8 (if (= tab-width 8) 4 32))))
    (redraw-display))
(global-set-key (kbd "<f8>") 'toggle-tab-size-setting)

;; Auto indent.
(define-key global-map (kbd "RET") 'newline-and-indent)

;; Configure package.el if emacs >= 24.
(when (>= emacs-major-version 24)
  (require 'package)
  (setq package-enable-at-startup nil)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")t))
  (package-initialize)

;; Load color theme.
(load-theme 'nord t)

;; Set window size
(when (display-graphic-p)
  (add-to-list 'default-frame-alist (cons 'width 120))
  (add-to-list 'default-frame-alist (cons 'height 40)))

;; Scroll one line at a time (less "jumpy" than defaults).
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(setq auto-window-vscroll nil) ;; extreme performance increase (10x)

;; Disable backup and autosave files.
(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files

;; Disable the games menu.
(define-key menu-bar-tools-menu [games] nil)

;; Show help of item under cursor.
(setq help-at-pt-display-when-idle t)
(setq help-at-pt-timer-delay 0.1)
(help-at-pt-set-timer)

;; Enable evil mode
(require 'evil)
(evil-mode 1)

;; Make esc.. escape.
(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(global-set-key [escape] 'evil-exit-emacs-state)

;; Enable powerline status bar.
(require 'powerline)
;;(setq powerline-image-apple-rgb t)
(powerline-center-evil-theme)

;; Enable paredit mode for various lisp and scheme modes.
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
  (add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
  (add-hook 'ielm-mode-hook             #'enable-paredit-mode)
  (add-hook 'lisp-mode-hook             #'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
  (add-hook 'scheme-mode-hook           #'enable-paredit-mode)

;; Enable Eclipse JDT Server mode
(add-to-list 'load-path "/Users/rubin/Syncthing/Source/Other/lsp-mode")
(add-to-list 'load-path "/Users/rubin/Syncthing/Source/Other/lsp-java")
(require 'lsp-mode)
(require 'lsp-java)
(setq lsp-java-server-install-dir "/Users/rubin/.vscode/extensions/redhat.java-0.31.0/server")
(add-hook 'java-mode-hook #'lsp-java-enable)

;; Custom settings below this line.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (forth-mode geiser paredit nord-theme markdown-mode yasnippet tide rust-mode rich-minority powerline popup intero evil cider)))
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(toggle-scroll-bar -1)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Fira Code" :foundry "outline" :slant normal :weight normal :height 140 :width normal)))))
