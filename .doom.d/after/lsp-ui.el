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
;; Its fill merges list items and code lines; join soft breaks instead.
(advice-add 'lsp-ui-doc--fill-document :override #'lsp-hover-join-lines)
;; It trims the hard line breaks, which the join must keep.
(advice-add 'lsp-ui-doc--inline-formatted-string
            :filter-args #'lsp-hover-mark-hard-breaks)
(advice-add 'lsp-ui-doc--make-smaller-empty-lines
            :before #'lsp-hover-replace-nbsp)
;; Workaround: rust-analyzer keeps hidden doctest lines in indented code.
(advice-add 'lsp-ui-doc--make-smaller-empty-lines
            :before #'lsp-hover-drop-hidden-lines)
(advice-add 'lsp-ui-doc--make-smaller-empty-lines
            :after #'lsp-hover-fill-code-gaps)
;; It removes the empty lines around headings; add space there and
;; around link definitions and code blocks.
(advice-add 'lsp-ui-doc--make-smaller-empty-lines
            :after #'lsp-hover-add-space)
;; Runs after the gaps in code blocks have the code face.
(advice-add 'lsp-ui-doc--handle-hr-lines :after #'lsp-hover-shade-code)
(advice-add 'lsp-ui-doc--handle-hr-lines :after #'lsp-hover-space-rules)
(add-hook 'window-size-change-functions #'lsp-hover-reflow)
(add-hook 'lsp-ui-doc-frame-hook #'lsp-hover-setup-frame)
;; A wider border to grab; it has the background color.
(setf (alist-get 'internal-border-width lsp-ui-doc-frame-parameters) 6)
;; A click must not take the keyboard; it stays there when hidden.
(setf (alist-get 'no-accept-focus lsp-ui-doc-frame-parameters) t)
(set-lookup-handlers! 'lsp-ui-mode
  :documentation '(lsp-ui-doc-show :async t))

;; It deletes the float on load-theme so that a new float gets the new
;; colors; auto-dark switches with enable-theme.
(add-hook 'enable-theme-functions (lambda (_) (lsp-ui-doc--delete-frame)))

;; No diagnostics beside code; C-w d shows them.
(setq lsp-ui-sideline-show-diagnostics nil)
