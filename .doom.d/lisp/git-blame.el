;;; $DOOMDIR/lisp/git-blame.el -*- lexical-binding: t; -*-

;; Git blame of the current line at its end, like current_line_blame.
(defface git-blame-line '((t :inherit shadow))
  "Face for the git blame of the current line.")

(defvar git-blame-line-delay 1.0
  "Seconds of idle time before the blame shows.")

(defvar git-blame-line--overlay nil)
(defvar git-blame-line--timer nil)
(defvar-local git-blame-line--user nil)

(defun git-blame-line--age (time)
  "Return how long ago TIME was, for example \"3 days ago\"."
  (let ((secs (- (float-time) time)))
    (cl-loop for (unit . size) in '(("year" . 31104000) ("month" . 2592000)
                                    ("day" . 86400) ("hour" . 3600)
                                    ("minute" . 60) ("second" . 1))
             for n = (floor secs size)
             when (or (>= n 1) (equal unit "second"))
             return (format "%d %s%s ago" n unit (if (> n 1) "s" "")))))

(defun git-blame-line--text (output)
  "Return the blame text for the porcelain OUTPUT of git blame."
  (let (fields)
    (dolist (line (split-string output "\n"))
      (when (string-match "\\`\\([a-z-]+\\) \\(.*\\)" line)
        (push (cons (match-string 1 line) (match-string 2 line)) fields)))
    (if (string-prefix-p "0000000000000000000000000000000000000000" output)
        " Not Committed Yet"
      (let ((author (alist-get "author" fields nil nil #'equal)))
        (format " %s, %s - %s "
                (if (equal author git-blame-line--user) "You" author)
                (git-blame-line--age
                 (string-to-number (alist-get "author-time" fields nil nil #'equal)))
                (alist-get "summary" fields nil nil #'equal))))))

(defun git-blame-line--clear ()
  "Remove the blame overlay."
  (when git-blame-line--overlay
    (delete-overlay git-blame-line--overlay)
    (setq git-blame-line--overlay nil)))

(defun git-blame-line--put (text)
  "Show TEXT at the end of the current line, cut to fit the window."
  (let* ((eol (line-end-position))
         (width (window-max-chars-per-line))
         (col (save-excursion (goto-char eol) (current-column)))
         (room (- width (% col width) 2)))
    (when (> room 0)
      (setq text (concat " " (truncate-string-to-width text room)))
      (put-text-property 0 1 'cursor t text)
      (setq git-blame-line--overlay (make-overlay eol eol))
      (overlay-put git-blame-line--overlay 'after-string
                   (propertize text 'face 'git-blame-line))
      (overlay-put git-blame-line--overlay 'tick
                   (buffer-chars-modified-tick)))))

(defun git-blame-line--show (buf)
  "Run git blame for the current line of BUF and show the result."
  (when (and (buffer-live-p buf) (eq buf (window-buffer)))
    (with-current-buffer buf
      (unless git-blame-line--user
        (setq git-blame-line--user
              (car (process-lines-ignore-status "git" "config" "user.name"))))
      (let* ((line (line-number-at-pos))
             (out (generate-new-buffer " *git-blame-line*"))
             (proc (make-process
                    :name "git-blame-line" :buffer out :noquery t
                    :connection-type 'pipe
                    :command (list "git" "blame" "--porcelain"
                                   "-L" (format "%d,%d" line line)
                                   "--contents" "-" "--" buffer-file-name)
                    :sentinel
                    (lambda (proc _)
                      (unless (process-live-p proc)
                        (let ((output (with-current-buffer out (buffer-string))))
                          (kill-buffer out)
                          (when (and (zerop (process-exit-status proc))
                                     (buffer-live-p buf))
                            (with-current-buffer buf
                              (when (= line (line-number-at-pos))
                                (git-blame-line--clear)
                                (git-blame-line--put
                                 (git-blame-line--text output)))))))))))
        (process-send-region proc (point-min) (point-max))
        (process-send-eof proc)))))

(defun git-blame-line--update ()
  "Hide the blame when the line changes and show it again when idle."
  (let ((ov git-blame-line--overlay))
    (unless (and ov
                 (eq (overlay-buffer ov) (current-buffer))
                 (= (overlay-start ov) (line-end-position))
                 (= (overlay-get ov 'tick) (buffer-chars-modified-tick)))
      (git-blame-line--clear)
      (when git-blame-line--timer
        (cancel-timer git-blame-line--timer))
      (when (and buffer-file-name (not (file-remote-p buffer-file-name)))
        (setq git-blame-line--timer
              (run-with-idle-timer git-blame-line-delay nil
                                   #'git-blame-line--show
                                   (current-buffer)))))))

(define-minor-mode git-blame-line-mode
  "Show the git blame of the current line at the end of the line."
  :global t
  (if git-blame-line-mode
      (add-hook 'post-command-hook #'git-blame-line--update)
    (remove-hook 'post-command-hook #'git-blame-line--update)
    (git-blame-line--clear)))
