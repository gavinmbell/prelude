;;; MIGRATION_EXAMPLES.el --- Example refactored configurations -*- lexical-binding: t -*-
;;
;; This file shows HOW to migrate your current config to the optimized structure.
;; DO NOT load this file directly - use it as a reference.

;;; Commentary:
;;
;; These examples show the BEFORE and AFTER for key configuration patterns.
;; Copy the AFTER versions to your new organized files.

;;; Code:

;; ============================================================================
;; EXAMPLE 1: Mac Keyboard Setup
;; ============================================================================

;; BEFORE (scattered across dot_emacs.el lines 27-30 and 438-442):
;; ----------------------------------------------------------------------------
;; (setq mac-option-key-is-meta nil
;;       mac-command-key-is-meta t
;;       mac-command-modifier 'meta
;;       mac-option-modifier 'none)
;;
;; ;; ... 400 lines later ...
;;
;; (setq mac-command-modifier 'meta)
;; (setq mac-option-modifier 'super)
;; (setq mac-control-modifier 'control)
;; (setq ns-function-modifier 'hyper)

;; AFTER (in personal/02-ui.el):
;; ----------------------------------------------------------------------------
(when (eq system-type 'darwin)
  ;; Mac keyboard modifiers
  ;; Cmd = Meta, Option = Super, Fn = Hyper
  (setq mac-command-modifier 'meta
        mac-option-modifier 'super
        mac-control-modifier 'control
        ns-function-modifier 'hyper)

  ;; Auto-adjust titlebar appearance
  (use-package ns-auto-titlebar
    :ensure t
    :config
    (ns-auto-titlebar-mode)))


;; ============================================================================
;; EXAMPLE 2: Aggressive Indent
;; ============================================================================

;; BEFORE (dot_emacs.el lines 85-101):
;; ----------------------------------------------------------------------------
;; (require 'aggressive-indent)
;; (global-aggressive-indent-mode 1)
;; (add-to-list 'aggressive-indent-excluded-modes 'html-mode)
;; (add-hook 'clojure-mode-hook 'paredit-mode)
;; (add-hook 'clojure-mode-hook 'aggressive-indent-mode)  ; REDUNDANT!
;; (add-hook 'emacs-lisp-mode-hook 'aggressive-indent-mode)  ; REDUNDANT!

;; AFTER (in personal/10-clojure.el):
;; ----------------------------------------------------------------------------
(use-package aggressive-indent
  :ensure t
  :defer t
  :diminish aggressive-indent-mode
  :hook ((clojure-mode . aggressive-indent-mode)
         (emacs-lisp-mode . aggressive-indent-mode))
  :config
  ;; Exclude modes where aggressive indent causes issues
  (add-to-list 'aggressive-indent-excluded-modes 'html-mode))

;; NOTE: No need for global-aggressive-indent-mode when using :hook
;; This loads the package only when needed


;; ============================================================================
;; EXAMPLE 3: Helm Configuration
;; ============================================================================

;; BEFORE (dot_emacs.el lines 64-66):
;; ----------------------------------------------------------------------------
;; (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
;; (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
;; (define-key helm-map (kbd "C-z") 'helm-select-action)

;; AFTER (in personal/01-keybindings.el):
;; ----------------------------------------------------------------------------
(with-eval-after-load 'helm
  ;; Make TAB more useful in Helm
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
  (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
  (define-key helm-map (kbd "C-z") 'helm-select-action))

;; NOTE: with-eval-after-load ensures these only run after helm loads


;; ============================================================================
;; EXAMPLE 4: Company Completion
;; ============================================================================

;; BEFORE (dot_emacs.el line 68):
;; ----------------------------------------------------------------------------
;; (global-set-key (kbd "C-<return>") 'company-complete)

;; AFTER (in personal/03-editing.el):
;; ----------------------------------------------------------------------------
(use-package company
  ;; Prelude already loads company, just customize it
  :bind (("C-<return>" . company-complete))
  :custom
  ;; Adjust company behavior if needed
  (company-idle-delay 0.2)
  (company-minimum-prefix-length 2)
  (company-tooltip-align-annotations t))


;; ============================================================================
;; EXAMPLE 5: Whitespace Management
;; ============================================================================

;; BEFORE (conflicting settings):
;; ----------------------------------------------------------------------------
;; ;; In dot_emacs.el line 61:
;; (setq whitespace-style '(face tabs empty trailing))
;;
;; ;; In dot_emacs.el line 408:
;; (setq prelude-whitespace nil)

;; AFTER (in personal/03-editing.el) - PICK ONE APPROACH:
;; ----------------------------------------------------------------------------
;; APPROACH A: Use Prelude's whitespace with your customization
(setq prelude-whitespace t  ; Let Prelude manage it
      whitespace-style '(face tabs empty trailing))  ; But customize the style

;; APPROACH B: Fully disable Prelude's whitespace
;; (setq prelude-whitespace nil)
;; ;; Then manage it yourself if needed


;; ============================================================================
;; EXAMPLE 6: Scrolling Functions (from keys.el)
;; ============================================================================

;; BEFORE (keys.el lines 93-136):
;; ----------------------------------------------------------------------------
;; This reverses standard Emacs C-v/M-v behavior which can be confusing

;; AFTER - RECOMMENDED: Keep standard Emacs behavior, add supplementary keys:
;; ----------------------------------------------------------------------------
;; Don't override C-v and M-v - keep standard Emacs behavior
;; Add supplementary keys for custom scrolling

;; Smooth scrolling by single lines
(global-set-key (kbd "C-S-v") 'scroll-down-in-place)  ; Changed from C-up
(global-set-key (kbd "M-S-v") 'scroll-up-in-place)    ; Changed from C-down

;; Horizontal scrolling
(global-set-key (kbd "C-S-<left>") 'scroll-right-one-column)
(global-set-key (kbd "C-S-<right>") 'scroll-left-one-column)

;; NOTE: Preserving standard C-v/M-v helps with:
;; - Consistency with other Emacs users
;; - Documentation and tutorials
;; - Muscle memory when using vanilla Emacs


;; ============================================================================
;; EXAMPLE 7: SQL Connections (if actively used)
;; ============================================================================

;; BEFORE (dot_emacs.el lines 310-340 - INSECURE):
;; ----------------------------------------------------------------------------
;; (setq sql-connection-alist '((rust-local-dev
;;                               (sql-password "password"))  ; PLAINTEXT!

;; AFTER (in personal/15-sql.el) - SECURE APPROACH:
;; ----------------------------------------------------------------------------
(use-package sql
  :defer t
  :config
  ;; Use auth-source for passwords instead of plaintext
  ;; Create ~/.authinfo.gpg with:
  ;; machine 127.0.0.1 port 5432 login postgres password YOUR_PASSWORD

  (setq sql-connection-alist
        '((rust-local-dev
           (sql-product 'postgres)
           (sql-server "127.0.0.1")
           (sql-port 5432)
           (sql-database "newsletter")
           (sql-user "postgres")
           ;; Password from auth-source
           (sql-password nil))))

  ;; Connection shortcuts
  (defun my-sql-local ()
    "Connect to local development database."
    (interactive)
    (let ((sql-password (auth-source-pick-first-password
                         :host "127.0.0.1"
                         :port "5432"
                         :user "postgres")))
      (sql-connect 'rust-local-dev))))


;; ============================================================================
;; EXAMPLE 8: DAP Mode Configuration
;; ============================================================================

;; BEFORE (dot_emacs.el lines 102-123):
;; ----------------------------------------------------------------------------
;; (require 'dap-cpptools)
;; (with-eval-after-load 'dap-cpptools ...

;; AFTER (in personal/12-rust.el if you use Rust):
;; ----------------------------------------------------------------------------
(use-package dap-mode
  :ensure t
  :defer t
  :after lsp-mode
  :commands (dap-debug dap-mode)
  :hook ((rust-mode . dap-mode)
         (dap-mode . dap-ui-mode))
  :custom
  (dap-default-terminal-kind "integrated")
  :config
  (require 'dap-cpptools)

  ;; Rust debugging template
  (dap-register-debug-template
   "Rust::CppTools Run Configuration"
   (list :type "cppdbg"
         :request "launch"
         :name "Rust::Run"
         :MIMode "gdb"
         :miDebuggerPath "rust-gdb"
         :program "${workspaceFolder}/target/debug/scaleness"
         :cwd "${workspaceFolder}"
         :console "external"
         :dap-compilation "cargo build"
         :dap-compilation-dir "${workspaceFolder}")))

;; NOTE: Only loads when you actually debug Rust code


;; ============================================================================
;; EXAMPLE 9: Zenburn Theme Customization
;; ============================================================================

;; BEFORE (dot_emacs.el lines 412-418):
;; ----------------------------------------------------------------------------
;; (with-eval-after-load "zenburn-theme"
;;   (zenburn-with-color-variables
;;     (custom-theme-set-faces 'zenburn ...

;; AFTER (in personal/02-ui.el):
;; ----------------------------------------------------------------------------
;; Theme is set in preload/theme.el, customize it here
(with-eval-after-load 'zenburn-theme
  (zenburn-with-color-variables
    (custom-theme-set-faces
     'zenburn
     ;; Darker background (bg-1 instead of bg)
     `(default ((t (:foreground ,zenburn-fg :background ,zenburn-bg-1))))
     ;; More visible region selection
     `(region ((t (:background ,zenburn-bg)))))))


;; ============================================================================
;; EXAMPLE 10: Performance Optimization
;; ============================================================================

;; NEW FILE: personal/preload/00-performance.el
;; ----------------------------------------------------------------------------
;;; 00-performance.el --- Startup performance optimizations -*- lexical-binding: t -*-

;; Increase GC threshold during startup for faster loading
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Reset to reasonable values after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024)  ; 16MB
                  gc-cons-percentage 0.1)
            (message "Emacs ready in %s with %d garbage collections."
                     (emacs-init-time)
                     gcs-done)))

;; Native compilation settings (Emacs 28+)
(when (and (fboundp 'native-comp-available-p)
           (native-comp-available-p))
  (setq native-comp-async-report-warnings-errors nil
        native-comp-deferred-compilation t
        native-comp-speed 2))

(provide '00-performance)


;; ============================================================================
;; EXAMPLE 11: Minimal prelude-modules.el
;; ============================================================================

;; BEFORE (21 modules):
;; ----------------------------------------------------------------------------
;; (require 'prelude-c)
;; (require 'prelude-clojure)
;; (require 'prelude-go)
;; (require 'prelude-haskell)
;; (require 'prelude-js)
;; ... 16 more ...

;; AFTER (minimal set - adjust to YOUR needs):
;; ----------------------------------------------------------------------------
;;; prelude-modules.el --- My essential Prelude modules -*- lexical-binding: t -*-

;; Interface
(require 'prelude-helm)
(require 'prelude-helm-everywhere)
(require 'prelude-company)

;; Core functionality
(require 'prelude-lsp)         ; Language Server Protocol support
(require 'prelude-org)         ; Org-mode for notes/TODOs

;; Languages I ACTIVELY use (uncomment only what you need)
(require 'prelude-emacs-lisp)  ; Always needed for Emacs configuration
(require 'prelude-clojure)     ; Clojure development

;; Add only if you code in these regularly:
;; (require 'prelude-go)
;; (require 'prelude-python)
;; (require 'prelude-rust)
;; (require 'prelude-js)

;; NOTE: Removed 15+ unused language modules
;; Each module adds ~0.1-0.3s to startup time
;; Start with minimum set, add back only if needed

(provide 'prelude-modules)
;;; prelude-modules.el ends here


;; ============================================================================
;; Summary of Key Improvements
;; ============================================================================

;; 1. Use-package pattern: Defer loading, diminish modes, clear dependencies
;; 2. No redundant hooks: Don't add hooks when global mode already enabled
;; 3. Secure credentials: Never plaintext passwords
;; 4. with-eval-after-load: Customize packages only after they load
;; 5. Organized by domain: UI, editing, languages separated
;; 6. Performance conscious: Lazy load everything possible
;; 7. Standard conventions: Don't override core Emacs keys unless necessary
;; 8. Documented: Clear comments on WHY, not just WHAT

;;; MIGRATION_EXAMPLES.el ends here
