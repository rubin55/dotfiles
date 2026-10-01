;;; $DOOMDIR/after/mcp-server.el -*- lexical-binding: t; -*-

;; Stop the server on exit, without a prompt about its process.
(add-hook 'kill-emacs-hook (lambda () (ignore-errors (mcp-server-stop))))
(advice-add 'mcp-server-start-unix :after
            (lambda (&rest _)
              (let ((proc (get-process "emacs-mcp-unix-server")))
                (when proc
                  (set-process-query-on-exit-flag proc nil)))))

;; Enable interactive prompting for permissions.
(setq mcp-server-security-prompt-for-permissions t)

;; Allow MCP access to *Messages*, shells and compilation output.
(setq mcp-server-security-sensitive-buffer-patterns nil)

;; Answering "!" in an MCP prompt allows all operations this session.
(defvar +mcp-allow-all nil)
(defadvice! +mcp-allow-all-a (fn op &optional data)
  :around #'mcp-server-security-check-permission
  (or +mcp-allow-all
      (prog1 (funcall fn op data)
        (when (gethash (format "%s:%s" op data)
                       mcp-server-security--permission-cache)
          (setq +mcp-allow-all t)))))
