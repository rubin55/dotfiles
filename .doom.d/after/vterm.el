;;; $DOOMDIR/after/vterm.el -*- lexical-binding: t; -*-

;; Keep hidden vterms open and show vterm buffers in the current window.
(setq vterm-toggle-hide-method nil)
(add-to-list 'display-buffer-alist
             '((lambda (buffer-or-name _)
                 (let ((buffer (get-buffer buffer-or-name)))
                   (with-current-buffer buffer
                     (or (equal major-mode 'vterm-mode)
                         (string-prefix-p vterm-buffer-name (buffer-name buffer))))))
               (display-buffer-reuse-window display-buffer-same-window)))
