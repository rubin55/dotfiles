;;; $DOOMDIR/after/astro-ts-mode.el -*- lexical-binding: t; -*-

;; No :lang module starts a language server for this mode.
(add-hook 'astro-ts-mode-local-vars-hook #'lsp! 'append)
