;;; $DOOMDIR/after/powershell.el -*- lexical-binding: t; -*-

;; No :lang module starts a language server for this mode.
(add-hook 'powershell-mode-local-vars-hook #'lsp! 'append)
