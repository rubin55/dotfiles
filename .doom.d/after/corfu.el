;;; $DOOMDIR/after/corfu.el -*- lexical-binding: t; -*-

;; Show completion docs in the float from K, without a corfu popup.
(remove-hook 'corfu-mode-hook #'corfu-popupinfo-mode)
(advice-add 'corfu--exhibit :after #'lsp-hover-completion-show)
(advice-add 'corfu--teardown :before #'lsp-hover-completion-hide)
