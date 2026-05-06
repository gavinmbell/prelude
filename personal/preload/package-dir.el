;;; package-dir.el --- Configure package directory location -*- lexical-binding: t -*-
;;
;; Copyright © 2026
;;
;; Author: cue
;;
;; This file is not part of GNU Emacs.

;;; Commentary:

;; Sets package-user-dir to be relative to Prelude install path.
;; This keeps all packages within .emacs.d/elpa/ rather than
;; using the default system package directory.
;;
;; This must be set in preload/ because it's used by core/prelude-packages.el
;; during initialization.

;;; Code:

;; Set to non-nil to keep packages in .emacs.d/elpa
;; (as opposed to default package directory)
(setq prelude-override-package-user-dir t)

(provide 'package-dir)

;;; package-dir.el ends here
