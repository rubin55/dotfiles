;;; $DOOMDIR/after/lsp-ui.el -*- lexical-binding: t; -*-

;; Show docs from K in a full-height float on the right of the window.
(advice-add 'lsp-ui-doc--render-buffer :before #'lsp-hover-prepare)
(advice-add 'lsp-ui-doc--render-buffer :after #'lsp-hover-wrap)
(advice-add 'lsp-ui-doc--move-frame :after #'lsp-hover-place)
(advice-add 'lsp-ui-doc--inline-p :override #'lsp-hover-inline-p)
;; A wrapped rule line makes mouse wheel scrolling stop in the float.
(advice-add 'lsp-ui-doc--fix-hr-props :override #'lsp-hover-fix-hr-props)
;; Terminals have no border to drag; drag the first column instead.
(define-key lsp-ui-doc-frame-mode-map [drag-mouse-1] #'lsp-hover-drag-edge)
;; Its fill-region merges code lines when one line is too wide.
(advice-add 'lsp-ui-doc--resize-buffer :override #'ignore)
(advice-add 'lsp-ui-doc--make-smaller-empty-lines
            :after #'lsp-hover-fill-code-gaps)
(add-hook 'window-size-change-functions #'lsp-hover-reflow)
(add-hook 'lsp-ui-doc-frame-hook #'lsp-hover-setup-frame)
;; A wider border to grab; it has the background color.
(setf (alist-get 'internal-border-width lsp-ui-doc-frame-parameters) 6)
;; A click must not take the keyboard; it stays there when hidden.
(setf (alist-get 'no-accept-focus lsp-ui-doc-frame-parameters) t)
(set-lookup-handlers! 'lsp-ui-mode
  :documentation '(lsp-ui-doc-show :async t))

;; No diagnostics beside code; C-w d shows them.
(setq lsp-ui-sideline-show-diagnostics nil)
