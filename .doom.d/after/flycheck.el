;;; $DOOMDIR/after/flycheck.el -*- lexical-binding: t; -*-

;; No diagnostics on mouse hover or in popups; C-w d shows them.
(setq flycheck-help-echo-function nil)
(remove-hook 'flycheck-mode-hook #'+syntax-init-popups-h)

;; Use my markdownlint config.
(setq flycheck-markdown-markdownlint-cli-config "~/.markdownlintrc")
