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

;; Indent and list marker at the start of a line; a space follows a
;; marker, so that *args in code is not a list item.
(defconst lsp-hover-prefix-regexp
  "[ \t]*\\(?:\\(?:[-*+]\\|[0-9]+[.)]\\)[ \t]+\\)?")

;; A line that starts a block: an empty line, list item, quote,
;; heading, table row or link definition.
(defconst lsp-hover-block-regexp
  (concat "[ \t]*\\(?:$\\|[-*+>][ \t]\\|[0-9]+[.)][ \t]"
          "\\|[#|]\\|\\[[^]\n]*]:\\)"))

(defun lsp-hover-join-lines ()
  "Join the lines of each paragraph and list item, except code.
The float wraps the long lines that this makes."
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "\n" nil t)
      (let ((nl (1- (point))))
        (unless (or (get-text-property (max (1- nl) (point-min))
                                       'lsp-hover-keep-lines)
                    (lsp-hover-code-face-p (max (1- nl) (point-min)))
                    (lsp-hover-code-face-p (point))
                    (get-text-property (point) 'markdown-hr)
                    (looking-at lsp-hover-block-regexp)
                    ;; This line is empty, a heading or a rule.
                    (save-excursion (goto-char nl)
                                    (beginning-of-line)
                                    (or (get-text-property (point) 'markdown-hr)
                                        (looking-at "[ \t]*\\(?:$\\|#\\)"))))
          (delete-region nl (progn (skip-chars-forward " \t") (point)))
          (insert " "))))))

(defun lsp-hover-mark-hard-breaks (args)
  "Mark the lines that end in a markdown hard break in the string of ARGS.
lsp-ui-doc trims the two spaces of the break; the text of the line
keeps the mark, so that the float does not join it with the next."
  (let ((string (copy-sequence (car args)))
        (start 0))
    (while (string-match "^\\(.*[^ \n]\\) \\{2,\\}$" string start)
      (put-text-property (match-beginning 1) (match-end 1)
                         'lsp-hover-keep-lines t string)
      (setq start (match-end 0)))
    (cons string (cdr args))))

(defun lsp-hover-replace-nbsp (&rest _)
  "Show the &nbsp; entities outside code as spaces.
basedpyright indents the lines of a docstring with them."
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "&nbsp;" nil t)
      (unless (lsp-hover-code-face-p (match-beginning 0))
        (replace-match " " t t)))))

(defun lsp-hover-drop-hidden-lines (&rest _)
  "Remove hidden doctest lines from the code in Rust docs.
This is a workaround: rust-analyzer removes the lines that start with
\"# \" from Rust code blocks, but it does not see a code fence that is
indented, for example in a list item. Rustdoc does not show these lines."
  (when (with-current-buffer (plist-get lsp-ui-doc--parent-vars :buffer)
          (derived-mode-p '(rust-mode rust-ts-mode rustic-mode)))
    (save-excursion
      (goto-char (point-min))
      (while (not (eobp))
        (cond ((not (and (looking-at "[ \t]*\\(#\\)")
                         (lsp-hover-code-face-p (match-beginning 1))))
               (forward-line 1))
              ;; Rustdoc shows ## as #.
              ((looking-at "[ \t]*\\(#\\)#")
               (delete-region (match-beginning 1) (match-end 1))
               (forward-line 1))
              ((looking-at "[ \t]*#\\(?: \\|$\\)")
               (delete-region (point) (line-beginning-position 2)))
              (t (forward-line 1)))))))

(defun lsp-hover-break-lines (width)
  "Break lines longer than WIDTH at word boundaries, except code."
  (save-excursion
    (goto-char (point-min))
    (while (not (eobp))
      (let ((bol (point))
            (eol (copy-marker (line-end-position))))
        (when (and (> (- eol bol) width) (not (lsp-hover-code-face-p bol)))
          ;; Indent the next lines under the text of a list item.
          (looking-at lsp-hover-prefix-regexp)
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
            word-wrap t
            ;; Wrapped list items align from the edge of the text area,
            ;; so pad with a margin; a line prefix is in the text area.
            line-prefix nil
            wrap-prefix nil
            left-margin-width 1)
      ;; The default also matches the hidden # of a heading.
      (setq-local adaptive-fill-regexp lsp-hover-prefix-regexp)
      (visual-wrap-prefix-mode 1)
      ;; Child frames in terminals do not show visual wrapping.
      (when tty
        (let ((inhibit-read-only t))
          (lsp-hover-break-lines (- lsp-ui-doc-max-width 2)))))))

(defun lsp-hover-code-face-p (pos)
  "Return non-nil if POS has the markdown code face."
  (memq 'markdown-code-face (ensure-list (get-text-property pos 'face))))

(defun lsp-hover-code-line-p ()
  "Return non-nil if the line at point is code.
Look past the indent: lsp-ui-doc puts a small space before line 2."
  (save-excursion
    (skip-chars-forward " \t")
    (lsp-hover-code-face-p (point))))

(defun lsp-hover-space-above (n)
  "Add N lines of space above the line at point."
  (unless (bobp)
    ;; The code shade fills the space below a code line; add a gap.
    (when (lsp-hover-code-face-p (1- (point)))
      (insert (propertize " " 'face '(:height 0.2))
              (propertize "\n" 'face '(:height 0.4))))
    (put-text-property (1- (point)) (point) 'line-spacing n)))

(defun lsp-hover-add-space (&rest _)
  "Add space around headings, link definitions and code blocks."
  (save-excursion
    (goto-char (point-min))
    (let ((link "\\[[^]\n]*]:")
          after-code)
      (while (not (eobp))
        (unless (looking-at "[ \t]*$")
          (let ((code (lsp-hover-code-line-p))
                (heading (get-text-property (point) 'markdown-heading)))
            ;; Above headings, the first link and text after code.
            (when (and (not code)
                       (not (get-text-property (point) 'markdown-hr))
                       (or heading
                           after-code
                           (and (looking-at link)
                                (not (save-excursion (forward-line -1)
                                                     (looking-at link))))))
              (lsp-hover-space-above 1.0))
            ;; Below headings and links.
            (when-let* ((n (cond (heading 0.2) ((looking-at link) 0.5))))
              (put-text-property (line-end-position) (line-beginning-position 2)
                                 'line-spacing n))
            (setq after-code code)))
        (forward-line 1)))))

(defun lsp-hover-space-rules (&rest _)
  "Add the same space above and below each rule line."
  (save-excursion
    (goto-char (point-min))
    (let (pos)
      (while (setq pos (text-property-any (point) (point-max)
                                          'lsp-ui-doc--replace-hr t))
        (goto-char pos)
        ;; Most servers have an empty line above the rule; basedpyright
        ;; does not.
        (unless (save-excursion (forward-line -1) (looking-at "[ \t]*$"))
          (insert (propertize " " 'face '(:height 0.2))
                  (propertize "\n" 'face '(:height 0.4))))
        (put-text-property (1- (point)) (point) 'line-spacing 0.3)
        (put-text-property (line-end-position) (line-beginning-position 2)
                           'line-spacing 0.3)
        (forward-line 1)))))

(defun lsp-hover-shade-code (&rest _)
  "Shade the code blocks after the first text; not the signature.
Mix a little of the text color into the background of the float."
  (let ((shade (apply #'format "#%04x%04x%04x"
                      (cl-mapcar (lambda (f b) (round (+ b (* 0.06 (- f b)))))
                                 (color-values (face-foreground 'default nil t))
                                 (color-values (face-background
                                                'lsp-ui-doc-background nil t)))))
        col)
    (save-excursion
      (goto-char (point-min))
      (while (not (eobp))
        (cond ((not (lsp-hover-code-line-p))
               ;; A block starts where the text before it starts; in a
               ;; list item, that is after the marker.
               (unless (looking-at "[ \t]*$")
                 (looking-at lsp-hover-prefix-regexp)
                 (setq col (- (match-end 0) (point))))
               (forward-line 1))
              (col (lsp-hover-shade-block shade col))
              (t (forward-line 1)))))))

(defun lsp-hover-shade-block (shade col)
  "Give the code block at point the background SHADE from column COL.
Start before COL if a line of the block is indented less."
  (let ((beg (point)))
    (while (and (not (eobp)) (lsp-hover-code-line-p))
      (unless (looking-at "[ \t]*$")
        (setq col (min col (current-indentation))))
      (forward-line 1))
    (save-excursion
      (let ((end (point)))
        (goto-char beg)
        (while (< (point) end)
          (if (not (looking-at "[ \t]*$"))
              (move-to-column col)
            ;; An empty line has no columns; show its space up to COL.
            (put-text-property (point) (line-end-position)
                               'display `(space :align-to ,col))
            (end-of-line))
          (add-face-text-property (point) (line-beginning-position 2)
                                  `(:background ,shade :extend t))
          (forward-line 1))))))

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
  "Draw rule lines as a thin line that does not wrap to a new row."
  (with-current-buffer (lsp-ui-doc--make-buffer-name)
    (let ((inhibit-read-only t)
          (pos (point-min)))
      (while (setq pos (text-property-any pos (point-max)
                                          'lsp-ui-doc--replace-hr t))
        ;; A background fills the full row; an overline is 1px.
        (put-text-property pos (1+ pos) 'face
                           `(:overline ,(face-foreground 'shadow nil t)))
        (put-text-property pos (1+ pos) 'display
                           '(space :align-to (- right-fringe 1) :height (1)))
        ;; Without a height, these make the row as tall as a text line.
        (put-text-property (1+ pos) (save-excursion (goto-char pos)
                                                    (line-end-position))
                           'display '(space :width 0 :height (1)))
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
    ;; Without the blank line, the float joins the two lines.
    (concat (propertize head 'face face) "\n\n"
            ;; Line breaks in a diagnostic are not soft markdown breaks.
            (propertize (lsp--render-string (flycheck-error-message err)
                                            "markdown")
                        'lsp-hover-keep-lines t))))

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
