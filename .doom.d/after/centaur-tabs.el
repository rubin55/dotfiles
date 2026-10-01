;;; $DOOMDIR/after/centaur-tabs.el -*- lexical-binding: t; -*-

(defun +dashboard-tabs-h (&optional _)
  "Show the tab bar in the dashboard only if files are open."
  (when-let* ((buf (get-buffer doom-fallback-buffer-name)))
    (with-current-buffer buf
      (setq-local tab-line-format
                  (and (seq-some #'buffer-file-name (+workspace-buffer-list))
                       (default-value 'tab-line-format))))))

;; Show all tabs in one group; mark the active tab with a top bar.
(setq centaur-tabs-buffer-groups-function
      (lambda () (list centaur-tabs-common-group-name)))
;; Also show a tab for the current buffer, unless in a side window.
(setq centaur-tabs-buffer-list-function
      (lambda ()
        (let ((buf (current-buffer)))
          (seq-uniq
           (append (+tabs-buffer-list)
                   (unless (window-parameter (get-buffer-window buf) 'window-side)
                     (list buf)))))))
;; Hide the tab bar only in internal buffers and ediff's control panel.
(setq centaur-tabs-excluded-prefixes
      '(" *which" " *Mini" " *temp" "*Ediff" "*ediff"))
;; Doom always hides the tab bar in the dashboard; decide on each change.
;; Run after Doom's dashboard reload, which can reset local variables.
(remove-hook '+dashboard-mode-hook #'+tabs-disable-centaur-tabs-mode-maybe-h)
(add-hook 'window-buffer-change-functions #'+dashboard-tabs-h 90)
(setq centaur-tabs-set-bar 'over)

;; Be able to switch buffers by clicking on their tab.
(setq mouse-1-click-follows-link -450)

(defvar centaur-tabs-pressed nil
  "The tab under the last mouse press on the tab line.")

(defun centaur-tabs-press (event)
  "Remember the tab under the mouse press EVENT."
  (interactive "e")
  (setq centaur-tabs-pressed (centaur-tabs-get-tab-from-event event)))

(defun centaur-tabs-release (event)
  "Move the pressed tab to the tab under EVENT, or select that tab."
  (interactive "e")
  (let* ((from centaur-tabs-pressed)
         (end (posn-string (event-end event)))
         (to (and end (get-text-property (cdr end) 'centaur-tabs-tab (car end)))))
    (setq centaur-tabs-pressed nil)
    (if (not (and from to (not (equal from to))))
        (centaur-tabs-do-select event)
      (let* ((tabset (centaur-tabs-tab-tabset from))
             (tabs (centaur-tabs-tabs tabset))
             (i (cl-position to tabs :test #'equal))
             (rest (remove from tabs)))
        (set tabset (append (seq-take rest i) (list from) (seq-drop rest i)))
        (centaur-tabs-set-template tabset nil)
        (centaur-tabs-display-update)))))

;; Drag a tab to move it; compare tabs, as terminals send a click.
(define-key centaur-tabs-default-map [tab-line down-mouse-1] #'centaur-tabs-press)
(define-key centaur-tabs-default-map [tab-line mouse-1] #'centaur-tabs-release)
(define-key centaur-tabs-default-map [tab-line drag-mouse-1] #'centaur-tabs-release)

(defun +centaur-tabs-close-tab-a (fn tab)
  "Kill the buffer of TAB with FN if it visits a file, else bury it.
Then show a real buffer in its windows, or the dashboard."
  (let* ((buf (centaur-tabs-tab-value tab))
         (windows (get-buffer-window-list buf)))
    (if (buffer-file-name buf)
        (funcall fn tab)
      ;; Its tab shows only while it is current, so this removes the tab.
      (with-current-buffer buf (bury-buffer)))
    (doom-fixup-windows (seq-filter #'window-live-p windows))))

(advice-add 'centaur-tabs-buffer-close-tab :around #'+centaur-tabs-close-tab-a)
