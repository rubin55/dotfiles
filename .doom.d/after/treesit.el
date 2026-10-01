;;; $DOOMDIR/after/treesit.el -*- lexical-binding: t; -*-

;; astro-ts-mode adds this recipe too late; keep it in sync with the pin.
(add-to-list 'treesit-language-source-alist
             '(astro "https://github.com/virchau13/tree-sitter-astro"
               :commit "213f6e6973d9b456c6e50e86f19f66877e7ef0ee"))
