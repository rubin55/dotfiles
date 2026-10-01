;;; $DOOMDIR/after/nov.el -*- lexical-binding: t; -*-

;; Do not fill the text; wrap it visually in a centered column.
(setq nov-text-width t)
(add-hook 'nov-mode-hook 'visual-fill-column-mode)
(add-hook 'nov-mode-hook 'adaptive-wrap-prefix-mode)
