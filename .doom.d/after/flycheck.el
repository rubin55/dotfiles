;;; $DOOMDIR/after/flycheck.el -*- lexical-binding: t; -*-

;; No diagnostics on mouse hover; C-w d shows them.
(setq flycheck-help-echo-function nil)

;; Use my markdownlint config.
(setq flycheck-markdown-markdownlint-cli-config "~/.markdownlintrc")
