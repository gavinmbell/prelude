;;; disable-ace-window.el --- Disable ace-window and restore default window switching -*- lexical-binding: t -*-
;;
;; Disable ace-window keybindings and restore standard other-window behavior

;;; Code:

;; Unbind ace-window from s-w
(global-unset-key (kbd "s-w"))

;; Restore the default other-window behavior (C-x o)
(global-set-key [remap other-window] nil)

;; If you want to completely unload ace-window (optional)
;; (with-eval-after-load 'ace-window
;;   (ace-window-mode -1))

(provide 'disable-ace-window)
;;; disable-ace-window.el ends here
