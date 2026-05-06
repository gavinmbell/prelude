;;; ensure-path.el --- Ensure ~/.local/bin is in PATH -*- lexical-binding: t -*-
;;
;; Make sure Claude CLI and other local binaries are accessible from Emacs

;;; Code:

;; Add ~/.local/bin to PATH if not already present
(let ((local-bin (expand-file-name "~/.local/bin")))
  (unless (member local-bin exec-path)
    (setq exec-path (cons local-bin exec-path))
    (setenv "PATH" (concat local-bin ":" (getenv "PATH")))))

(provide 'ensure-path)
;;; ensure-path.el ends here
