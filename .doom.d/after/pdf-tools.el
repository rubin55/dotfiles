;;; $DOOMDIR/after/pdf-tools.el -*- lexical-binding: t; -*-

;; Show PDFs in midnight (dark) mode.
(add-hook 'pdf-misc-minor-mode-hook 'pdf-view-midnight-minor-mode)
