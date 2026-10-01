;;; $DOOMDIR/after/svelte-mode.el -*- lexical-binding: t; -*-

;; No :lang module starts a language server for this mode.
(add-hook 'svelte-mode-local-vars-hook #'lsp! 'append)
