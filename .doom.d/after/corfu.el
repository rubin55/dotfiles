;;; $DOOMDIR/after/corfu.el -*- lexical-binding: t; -*-

;; Show completion docs in the float from K.
(advice-add 'corfu--exhibit :after #'lsp-hover-completion-show)
(advice-add 'corfu--teardown :before #'lsp-hover-completion-hide)
