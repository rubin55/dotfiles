;;; $DOOMDIR/after/treemacs.el -*- lexical-binding: t; -*-

;; Use the doom-themes icons in treemacs, with monospace labels.
;; Doom's treemacs-nerd-icons is disabled in packages.el.
(setq doom-themes-treemacs-theme "doom-colors"
      doom-themes-treemacs-enable-variable-pitch nil)
(doom-themes-treemacs-config)

(defun +treemacs-search-path-p (path)
  "Return non-nil if PATH is in the projectile search path."
  (seq-some (lambda (dir) (file-in-directory-p path (car dir)))
            projectile-project-search-path))

(defun +treemacs-tidy-a ()
  "Remove duplicate workspaces and projects outside the search path.
Lowercase and sort the projects that stay."
  (let* ((ws (treemacs-current-workspace))
         (names (mapcar #'treemacs-project->name
                        (treemacs-workspace->projects ws))))
    ;; Renaming a perspective to a used name makes a duplicate.
    (setq treemacs--workspaces
          (cl-remove-duplicates treemacs--workspaces :from-end t
                                :key #'treemacs-workspace->name
                                :test #'string=))
    (dolist (w treemacs--workspaces)
      (dolist (p (treemacs-workspace->projects w))
        (setf (treemacs-project->name p) (downcase (treemacs-project->name p))))
      (setf (treemacs-workspace->projects w)
            (sort (seq-filter (lambda (p)
                                (+treemacs-search-path-p (treemacs-project->path p)))
                              (treemacs-workspace->projects w))
                  :key #'treemacs-project->name)))
    (cond ((not (memq ws treemacs--workspaces))
           (treemacs-persp--on-perspective-switch))
          ((not (equal names (mapcar #'treemacs-project->name
                                     (treemacs-workspace->projects ws))))
           (treemacs--consolidate-projects)))))

(defun +treemacs-add-current-project-h ()
  "Add the current project to treemacs if it is in the search path."
  (when-let* ((root (projectile-project-root))
              ((+treemacs-search-path-p root)))
    (treemacs-do-add-project-to-workspace root (projectile-project-name root))))

(defun +treemacs-sync-workspace-h ()
  "Tidy the workspace, then add the projects of all its files."
  ;; A new workspace can get a project outside the search path.
  (+treemacs-tidy-a)
  (dolist (buf (seq-filter #'buffer-file-name (+workspace-buffer-list)))
    (with-current-buffer buf (+treemacs-add-current-project-h))))

;; Doom disables follow mode by default.
(treemacs-follow-mode 1)
(add-hook 'find-file-hook #'+treemacs-add-current-project-h)
(add-hook 'treemacs-switch-workspace-hook #'+treemacs-sync-workspace-h)
;; All project changes are persisted, so tidy up before that.
(advice-add 'treemacs--persist :before #'+treemacs-tidy-a)
