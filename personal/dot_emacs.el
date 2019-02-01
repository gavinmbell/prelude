;;; init.el --- My old .emacs file
;;
;;******************************************************
;;*  Program Name: Emacs
;;*  Project Name: SELF
;;*  Organization: The 6th Column Group
;;*  Coordinator : Gavin M. Bell
;;*
;;* Description: The resource file for .emacs... nuff said
;;*
;;******************************************************

;;; Commentary:

;;; License:

;;; Code:
(setq inhibit-splash-screen t)
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
;;(setq transient-mark-mode nil)
(global-linum-mode 1)
(global-hl-line-mode 0)

(setq mac-option-key-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'meta
      mac-option-modifier 'none)

(put 'narrow-to-region 'disabled nil)

;; initial window
(setq initial-frame-alist
      '(
        (width . 102)
        (height . 54)
        (left . 50)
        (top . 50)))

(setq default-frame-alist
      '(
        (width . 100)
        (height . 52)
        (left . 50)
        (top . 50)))

(require 'ns-auto-titlebar)
(when (eq system-type 'darwin) (ns-auto-titlebar-mode))

(load-theme 'zenburn t)
(add-hook 'sh-mode-hook 'flycheck-mode)

;(require 'cljr-helm)

;;Don't like the 80 column thing so overriding the following, but without the ""lines-tail""
;; core/prelude-editor.el
;; 341:(setq whitespace-style '(face tabs empty trailing lines-tail))
(setq whitespace-style '(face tabs empty trailing))


(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(global-set-key (kbd "C-<return>") 'company-complete)
(global-set-key (kbd "M-\`") 'other-frame)

(setq tramp-default-user "${USER}")

;;------------------
;; no need to do this because cider has a load process that picks
;; these up from directory
;;------------------
;;(load "~/.emacs.d/personal/overlay-fix.el")
;;(load "~/.emacs.d/personal/keys.el")
;;(load "~/.emacs.d/custom/frills.el")
;;(load "~/.emacs.d/personal/half-height.el")
;;(load "~/.emacs.d/personal/misc.el")
;;------------------


(add-hook 'clojure-mode-hook 'paredit-mode)
;;(add-hook 'clojure-mode-hook 'auto-complete-mode)
;;
;;
(setq cider-repl-clear-help-banner nil)
;;(setq locale-coding-system 'utf-8)
;;(set-terminal-coding-system 'utf-8)
;;(set-keyboard-coding-system 'utf-8)
;;(set-selection-coding-system 'utf-8)
;;(prefer-coding-system 'utf-8)
;;
;;(global-set-key "\C-cf" 'auto-fill-mode)
;;
;;(add-to-list 'load-path "~/.emacs.d/")
;;(require 'package)
;;(add-to-list 'package-archives
;;         '("marmalade" . "http://marmalade-repo.org/packages/"))
;;         ;;    '("melpa" . "http://melpa.milkbox.net/packages/") t)
;;(package-initialize)
;;
;;;;http://magit.github.com/magit/magit.html
;;(require 'magit)
;;(require 'magit-topgit)
;;(global-set-key "\C-cg" 'magit-status)
;;(transient-mark-mode 'disabled)
;;
;;(global-set-key "\M-n" 'next-error)
;;(global-set-key "\M-p" 'previous-error)
;;(global-set-key "\C-h" 'delete-backward-char)
;;(global-set-key "\C-xg" 'goto-line)
;;(global-set-key "\M-g" 'goto-line)
(global-set-key "\C-xp" 'revert-buffer)
;;(global-set-key "\C-x\C-p" 'revert-buffer)
;;(global-set-key "\M-R" 'replace-string)
;;(global-set-key "\e." 'find-tag-other-frame)
;;(global-set-key "\C-x." 'find-tag)
;;
;;(global-set-key "\M-s" 'search-forward-regexp)
;;
;;(global-set-key [M-up] 'move-text-up)
;;(global-set-key [M-down] 'move-text-down)
;;
;;;;-----
;;;;source code formatting prefs.
;;;;-----
;;(setq c-basic-offset 4)
;;(setq tab-width 4)
;;(setq indent-tabs-mode nil)
;;
;;(setq-default c-basic-offset 4)
;;(setq-default indent-tabs-mode nil)
;;
;;(defun my-java-mode-hook ()
;;  (setq c-basic-offset 4)
;;  (setq tab-width 4)
;;  (setq indent-tabs-mode nil))
;;(add-hook 'java-mode-hook 'my-java-mode-hook)
;;(add-hook 'java-mode-hook 'subword-mode)
;;
(global-set-key "\C-\M-]" 'untabify)
;;;;-----
;;
;;(setq minibuffer-max-depth nil)
;;
;;(display-time)
;;(setq auto-save-interval 900)
;;(setq line-number-mode t)
;;(setq frame-title-format
;;  '("%S: " (buffer-file-name "%f" (dired-directory dired-directory "%b"))))
;;
;;(setq default-major-mode 'text-mode)
;;(setq initial-major-mode 'text-mode)
;;(setq scroll-step 1)
;;(mouse-wheel-mode t)
;;(setq text-mode-hook '(lambda () (auto-fill-mode 1)))
;;(setq font-lock-maximum-decoration t)
;;
;;(require 'paren)
;;(show-paren-mode 1)
;;;;  (paren-set-mode 'sexp)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Looks...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;(set-face-attribute 'default nil)
;;(set-face-background 'default      "black")     ; frame background
;;(set-face-foreground 'default      "navajowhite")      ; normal text
;;
;;;;(set-face-background 'default      "wheat")     ; frame background
;;;;(set-face-foreground 'default      "black")      ; normal text
;;
;;(set-face-background 'highlight    "black")       ; Ie when selecting buffers
;;(set-face-foreground 'highlight    "yellow")
;;(set-face-background 'mode-line     "DarkSlateGray")       ; Line at bottom of buffer
;;(set-face-foreground 'mode-line     "wheat")
;;(set-face-background 'scroll-bar   "DarkSlateGray")
;;(setq x-pointer-foreground-color   "green")      ; Adds to bg color,
;;                                                 ; so keep black
;;(setq x-pointer-background-color   "blue")       ; This is color you really
;;                                                 ; want ptr/crsr
;;(setq font-lock-use-default-fonts "fixed")
;;;;(setq font-lock-use-default-colors "green")
;;
;;(copy-face 'default 'font-lock-comment-face)
;;(set-face-foreground 'font-lock-comment-face "tan")
;;(copy-face 'default 'font-lock-variable-name-face)
;;(set-face-foreground 'font-lock-variable-name-face "palegreen")
;;(copy-face 'default 'font-lock-type-face)
;;(set-face-foreground 'font-lock-type-face "coral")
;;(copy-face 'italic 'font-lock-string-face)
;;(set-face-foreground 'font-lock-string-face "lightgray")
;;(copy-face 'default 'font-lock-function-name-face)
;;(set-face-foreground 'font-lock-function-name-face "white")
;;(copy-face 'default 'font-lock-keyword-face)
;;(set-face-foreground 'font-lock-keyword-face "goldenrod")
;;(copy-face 'default 'font-lock-reference-face)
;;(set-face-foreground 'font-lock-reference-face "goldenrod")
;;
;;(put 'eval-expression 'disabled nil)
;;(put 'upcase-region 'disabled nil)
;;
;;(defun replace-sequence (from pre start total query-flag regexp-flag)
;;  (let ((cur (- (+ start total) 1)) (pt 0)
;;    (repl nil) (str (concat pre "%d")))
;;    (while (< pt total)
;;      (setq repl (cons (format str cur) repl))
;;      (setq pt (+ pt 1))
;;      (setq cur (- cur 1)))
;;    (perform-replace from repl query-flag regexp-flag nil)))
;;
;;(custom-set-variables
;; '(paren-mode (quote paren) nil (paren))
;; '(column-number-mode t)
;; '(default-toolbar-position (quote right))
;; '(mode-line-click-swaps-buffers t)
;; '(user-mail-address "cue@garvey.6thcolumn.org" t)
;; '(query-user-mail-address nil))
;;(custom-set-faces)
;;
(setq split-width-threshold nil)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; SQL Mode connection configurations, etc...                              ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(setq sql-connection-alist '((rlprod (sql-product 'postgres)
;;                                     (sql-server "ec2-23-23-211-161.compute-1.amazonaws.com")
;;                                     (sql-port 5432)
;;                                     (sql-database "d8c4dkc4cu8jle")
;;                                     (sql-user "ffdpqvfpogqsad")
;;                                     (sql-password "w89ZJJ5VphBfWA_fVx9nPiAyFT"))
;;                             (rldev (sql-product 'postgres)
;;                                    (sql-server "ec2-54-221-204-39.compute-1.amazonaws.com")
;;                                    (sql-port 5432)
;;                                    (sql-database "d7to43aeu5c3iq")
;;                                    (sql-user "byobjvlkzbrqan")
;;                                    (sql-password "Of3c-_LHvnD-T1Di1UqYWYC6AE"))
;;                             (rllocal (sql-product 'postgres)
;;                                      (sql-server "localhost")
;;                                      (sql-port 5432)
;;                                      (sql-database "ringleader")
;;                                      (sql-user "rluser")
;;                                      (sql-password "letmein")
;;                                      )))
;;
;;(defun sql-connect-preset (name)
;;  "Connect to a predefined SQL connection listed in `sql-connection-alist'"
;;  (eval `(let ,(cdr (assoc name sql-connection-alist))
;;    (flet ((sql-get-login (&rest what)))
;;      (sql-product-interactive sql-product)))))
;;
;;(defun sql-rl-prod ()
;;  (interactive)
;;  (sql-connect-preset 'rlprod))
;;
;;(defun sql-rl-dev ()
;;  (interactive)
;;  (sql-connect-preset 'rldev))
;;
;;(defun sql-rl-local ()
;;  (interactive)
;;  (sql-connect-preset 'rllocal))
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; MUDS!:                                                                  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;;jmud stuff
;;(setq load-path (cons (expand-file-name "~/.emacs.d/custom/moolisp")
;;                      load-path))
;;(autoload 'moo-code-mode "j-moo-code" "Major mode for editing MOO-code." t)
;;(setq auto-mode-alist (cons '("\\.moo$" . moo-code-mode) auto-mode-alist))
;;(global-set-key "\C-cm" 'mud)
;;(setq moo-use-@program t)
;;(setq moo-browser-worlds '(("LambdaMOO")))
;;(setq use-suppress-all-input t)
;;(setq moo-filter-hook
;;      (setq tinymud-filter-hook
;;            '(mud-check-triggers mud-check-reconnect mud-fill-lines)))
;;(setq jmud-directory (expand-file-name "~/.emacs.d/custom/moolisp"))
;;(setq j-mud-libraries-list
;;      (list
;;       "j-mud-worlds"
;;       "j-mud"
;;       "j-mud-get"
;;       "j-mud-macros"
;;       "j-mud-history"
;;       "j-mud-upload"
;;       "prefix"
;;       "j-boom-tree"
;;       "j-boom-obj"
;;       "j-boom"
;;       "j-lp"
;;       "j-tiny"
;;       "j-moo"
;;       "j-moo-code"))
;;(defun j-mud-load () (interactive) (mapcar 'load-library j-mud-libraries-list))
;;(j-mud-load)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Misc misc...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
(global-set-key "\C-cp" 'paredit-mode)
(global-set-key "\C-c\M-j" 'cider-jack-in)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Keyboard Macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;
;;(defalias 'dos2unix (read-kbd-macro
;;"ESC < ESC x repl TAB st TAB RET C-q C-m 2*RET ESC <"))
;;(global-set-key "\C-cu" 'dos2unix)
;;
;;(defalias 'unix2dos (read-kbd-macro
;;"ESC x replace- e <backspace> reg TAB RET $ RET C-q C-m RET ESC <"))
;;(global-set-key "\C-cU" 'unix2dos)
;;
;;(defalias 'header (read-kbd-macro
;;"ESC < C-x i C-a 2*<C-f> C-k .emacs 5*<backspace> header RET C-s des C-f C-e RET TAB"))
;;(global-set-key "\C-ch" 'header)
;;
;;(defalias 'putheader (read-kbd-macro
;;"ESC < ESC x inser TAB f TAB RET .he TAB RET C-s des C-e RET TAB"))

;;-----------------------------------------------------------------

(with-eval-after-load "zenburn-theme"
     (zenburn-with-color-variables
            (custom-theme-set-faces
                   'zenburn
                   ;; original `(default ((t (:foreground ,zenburn-fg :background ,zenburn-bg))))
                   `(default ((t (:foreground ,zenburn-fg :background ,zenburn-bg-1))))
                   (set-face-background 'region zenburn-bg))))


(defun my-flymd-browser-function (url)
  (let ((process-environment (browse-url-process-environment)))
    (apply 'start-process
           (concat "firefox " url)
           nil
           "/usr/bin/open"
           (list "-a" "firefox" url))))
(setq flymd-browser-open-function 'my-flymd-browser-function)
(setq mouse-autoselect-window t)
(setq focus-follows-mouse t)

;;Because I don't like SWIPER...
(global-unset-key "\C-s")
(global-set-key "\C-s" 'isearch-forward)

;;-----------------------------------
;; Make my keys the way I like them on my mac
;;-----------------------------------
(setq mac-command-modifier 'meta) ; make cmd key do Meta
(setq mac-option-modifier 'super) ; make opt key do Super
(setq mac-control-modifier 'control) ; make Control key do Control
(setq ns-function-modifier 'hyper)  ; make Fn key do Hyper
;;-----------------------------------

;;(setq magithub-debug-mode t)
