;;; $DOOMDIR/lisp/lsp-hover.el -*- lexical-binding: t; -*-

;; Show docs, diagnostics and completion docs from LSP in a float
;; on the right side of the window. after/lsp-ui.el and
;; after/corfu.el connect these functions to the packages.

;; Width of the float from K as a share of its window; a drag sets it.
(defvar lsp-hover-width 0.4)

;; Arguments of the last `lsp-ui-doc--render-buffer' call.
(defvar lsp-hover-last nil)

(defun lsp-hover-prepare (&rest args)
  "Remember ARGS and wrap the documentation to fit the float."
  (setq lsp-hover-last args
        lsp-ui-doc-max-width (round (* lsp-hover-width (window-body-width)))))

(defun lsp-hover-span (win)
  "Return the left and right pixel edges of WIN that the float may cover."
  (cons (car (window-inside-pixel-edges win))
        (- (nth 2 (window-pixel-edges win))
           (window-right-divider-width win)
           (window-scroll-bar-width win))))

(defun lsp-hover-place (&rest _)
  "Put the documentation float on the right side of its window."
  (when-let* ((frame (lsp-ui-doc--get-frame))
              (win (frame-parameter frame 'lsp-ui-doc--window-origin))
              ((window-live-p win)))
    (pcase-let* ((`(,left . ,right) (lsp-hover-span win))
                 (`(_ ,top _ ,bottom) (window-inside-pixel-edges win))
                 (width (round (* lsp-hover-width (- right left))))
                 ;; Border size; terminals do not draw internal borders.
                 (bw (- (frame-pixel-width frame) (frame-text-width frame)))
                 (bh (- (frame-pixel-height frame) (frame-text-height frame))))
      (modify-frame-parameters
       frame `((left . (+ ,(- right width)))
               (top . (+ ,top))
               (width . (text-pixels . ,(- width bw)))
               (height . (text-pixels . ,(- bottom top bh))))))))

(defun lsp-hover-reflow (frame)
  "Wrap and place the documentation float again after FRAME resizes."
  (when-let* ((doc (lsp-ui-doc--get-frame))
              ((frame-visible-p doc))
              (win (frame-parameter doc 'lsp-ui-doc--window-origin))
              ((window-live-p win)))
    ;; A resize of the float itself comes from a mouse drag.
    (when (eq frame doc)
      (let ((span (lsp-hover-span win)))
        (setq lsp-hover-width (/ (float (frame-pixel-width doc))
                               (- (cdr span) (car span))))))
    (with-selected-window win
      (apply #'lsp-ui-doc--render-buffer lsp-hover-last)
      (lsp-hover-place)
      (lsp-ui-doc--fix-hr-props))))

(defun lsp-hover-break-lines (width)
  "Break lines longer than WIDTH at word boundaries, except code."
  (save-excursion
    (goto-char (point-min))
    (while (not (eobp))
      (let ((bol (point))
            (eol (copy-marker (line-end-position))))
        (when (and (> (- eol bol) width) (not (lsp-hover-code-face-p bol)))
          ;; Indent the next lines under the text of a list item.
          (looking-at "[ \t]*\\([-*+]\\|[0-9]+[.)]\\)?[ \t]*")
          (let ((fill-column width)
                (fill-prefix (make-string (- (match-end 0) bol) ?\s)))
            (fill-region-as-paragraph bol eol)))
        (goto-char eol)
        (forward-line 1)))))

(defun lsp-hover-wrap (&rest _)
  "Wrap long lines in the documentation float at word boundaries."
  (let ((tty (not (display-graphic-p))))
    (with-current-buffer (lsp-ui-doc--make-buffer-name)
      (setq truncate-lines nil
            word-wrap t)
      (visual-wrap-prefix-mode 1)
      ;; Child frames in terminals do not show visual wrapping.
      (when tty
        (let ((inhibit-read-only t))
          (lsp-hover-break-lines (- lsp-ui-doc-max-width 2)))))))

(defun lsp-hover-code-face-p (pos)
  "Return non-nil if POS has the markdown code face."
  (memq 'markdown-code-face (ensure-list (get-text-property pos 'face))))

(defun lsp-hover-fill-code-gaps (&rest _)
  "Give empty lines inside code blocks the code background."
  (save-excursion
    (goto-char (point-min))
    (while (not (eobp))
      ;; lsp-ui-doc turns each empty line into a small " \n" line.
      (when (and (looking-at " \n")
                 (> (point) 1)
                 (lsp-hover-code-face-p (1- (point)))
                 (lsp-hover-code-face-p (+ (point) 2)))
        (add-face-text-property (point) (+ (point) 2) 'markdown-code-face t))
      (forward-line 1))))

(defun lsp-hover-drag-edge (event)
  "Resize the documentation float with a drag from its first column."
  (interactive "e")
  (let* ((doc (lsp-ui-doc--get-frame))
         (win (frame-parameter doc 'lsp-ui-doc--window-origin))
         (start (event-start event))
         (end (event-end event)))
    (if (not (zerop (car (posn-col-row start))))
        (mouse-set-region event)
      (pcase-let* ((`(,left . ,right) (lsp-hover-span win))
                   (endwin (posn-window end))
                   (x (+ (car (posn-x-y end))
                         (if (eq (window-frame endwin) doc)
                             (car (frame-position doc))
                           (car (window-inside-pixel-edges endwin))))))
        (setq lsp-hover-width
              (min 0.9 (max 0.1 (/ (float (- right x)) (- right left)))))
        (lsp-hover-reflow nil)))))

(defun lsp-hover-fix-hr-props ()
  "Draw rule lines so that nothing on their line wraps to a new row."
  (with-current-buffer (lsp-ui-doc--make-buffer-name)
    (let ((inhibit-read-only t)
          (pos (point-min)))
      (while (setq pos (text-property-any pos (point-max)
                                          'lsp-ui-doc--replace-hr t))
        (put-text-property pos (1+ pos) 'display
                           '(space :align-to (- right-fringe 1) :height (1)))
        (put-text-property (1+ pos) (save-excursion (goto-char pos)
                                                    (line-end-position))
                           'display '(space :width 0))
        (setq pos (1+ pos))))))

(defun lsp-hover-inline-p ()
  "Return non-nil when the documentation cannot use a child frame."
  (or (not lsp-ui-doc-use-childframe)
      (not (or (display-graphic-p) (featurep 'tty-child-frames)))))

(defun lsp-hover-setup-frame (frame _window)
  "Hide the border and window dividers of FRAME."
  (let ((bg (frame-parameter frame 'background-color)))
    (set-face-background 'internal-border bg frame)
    (set-face-background 'child-frame-border bg frame)
    (modify-frame-parameters frame '((right-divider-width . 0)
                                     (bottom-divider-width . 0)))))

(defun lsp-hover-diagnostic-string (err)
  "Render flycheck ERR as a header in its level color above its message."
  ;; lsp-mode's own levels use the fringe face of their base level.
  (let* ((face (flycheck-error-level-fringe-face (flycheck-error-level err)))
         (level (string-remove-prefix "flycheck-fringe-" (symbol-name face)))
         (head (mapconcat (lambda (part) (format "%s" part))
                          (delq nil (list (upcase level)
                                          (or (flycheck-error-group err)
                                              (flycheck-error-checker err))
                                          (flycheck-error-id err)))
                          " ")))
    ;; Without the blank line, the fill of the float can join the two.
    (concat (propertize head 'face face) "\n\n"
            (lsp--render-string (flycheck-error-message err) "markdown"))))

(defun lsp-hover-diagnostics ()
  "Show the diagnostics of the current line in the float from K."
  (interactive)
  (require 'lsp-ui)
  (let ((line (line-number-at-pos)))
    (if-let* ((errs (seq-filter (lambda (err) (eql (flycheck-error-line err) line))
                                (bound-and-true-p flycheck-current-errors))))
        (lsp-ui-doc--display
         "" (mapconcat #'lsp-hover-diagnostic-string errs "\n\n\n"))
      (message "No diagnostics"))))

;; Candidate whose docs are requested, and if the float shows them.
(defvar lsp-hover-candidate nil)
(defvar lsp-hover-completion-shown nil)

(defun lsp-hover-completion-string (item)
  "Render the docs of completion ITEM, with the signature on top if new."
  (let* ((detail (lsp:completion-item-detail? item))
         (docs (lsp:completion-item-documentation? item))
         (raw (if (stringp docs) docs (and docs (lsp:markup-content-value docs))))
         (text (lsp--render-element docs)))
    (if (and detail (not (string-search detail (or raw ""))))
        (concat (lsp--render-string detail (lsp-buffer-language)) "\n\n" text)
      text)))

(defun lsp-hover-completion-show (&rest _)
  "Show the docs of the selected LSP completion candidate in the float."
  (let ((cand (and (>= corfu--index 0) (nth corfu--index corfu--candidates)))
        (win (selected-window)))
    (unless (eq cand lsp-hover-candidate)
      (setq lsp-hover-candidate cand)
      (when (and cand (get-text-property 0 'lsp-completion-item cand))
        (lsp-completion--resolve-async
         cand
         (lambda (item)
           ;; Skip a reply for a candidate that is no longer selected.
           (when (and (eq cand lsp-hover-candidate) (window-live-p win))
             (with-selected-window win
               (let ((doc (lsp-hover-completion-string item)))
                 (unless (string-blank-p doc)
                   (lsp-ui-doc--display "" doc)
                   (setq lsp-hover-completion-shown t)))))))))))

(defun lsp-hover-completion-hide (&rest _)
  "Hide the float when it shows completion docs."
  (setq lsp-hover-candidate nil)
  (when lsp-hover-completion-shown
    (setq lsp-hover-completion-shown nil)
    (lsp-ui-doc--hide-frame)))
