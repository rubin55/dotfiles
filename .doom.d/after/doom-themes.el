;;; $DOOMDIR/after/doom-themes.el -*- lexical-binding: t; -*-

;; Disable bold.
(setq doom-themes-enable-bold nil)

;; More contrast for the mode line in both rose-pine variants.
;; The themes require doom-themes, so this is set before they load.
(setq doom-rose-pine-dawn-brighter-modeline t
      doom-rose-pine-moon-brighter-modeline t)
