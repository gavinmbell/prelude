;;; my_claude_code_ide.el --- Claude Code IDE integration with MCP support -*- lexical-binding: t -*-
;;
;; Setup for claude-code-ide package with Model Context Protocol (MCP) integration
;; Provides deep Emacs integration with Claude Code CLI

;;; Commentary:
;;
;; This module sets up claude-code-ide with:
;; - Manual installation from vendor/ directory
;; - MCP server integration enabled
;; - Terminal backend (vterm preferred, falls back to eat)
;; - Custom keybindings
;; - Multi-project session support
;;
;; https://github.com/manzaltu/claude-code-ide.el

;;; Code:

;; Add claude-code-ide to load-path
(add-to-list 'load-path (expand-file-name "vendor/claude-code-ide" user-emacs-directory))

;; Required dependencies for claude-code-ide
;; websocket: WebSocket client/server library for MCP protocol
(use-package websocket
  :ensure t
  :defer t)

;; web-server: HTTP server library for MCP tools server
(use-package web-server
  :ensure t
  :defer t)

;; Use vterm as terminal backend (native C, much faster)
;; Note: Requires compiling a native module (see VTERM_SETUP.md)
;; Built successfully on: May 6, 2026
(use-package vterm
  :ensure t
  :defer t
  :custom
  (vterm-max-scrollback 10000)
  (vterm-buffer-name-string "vterm: %s")
  (vterm-timer-delay 0.01)
  (vterm-kill-buffer-on-exit t)
  :config
  ;; Pass navigation keys back to Emacs instead of sending to terminal
  (define-key vterm-mode-map (kbd "C-<up>") #'scroll-up-in-place)
  (define-key vterm-mode-map (kbd "C-<down>") #'scroll-down-in-place)
  (define-key vterm-mode-map (kbd "C-<left>") #'partial-scroll-right)
  (define-key vterm-mode-map (kbd "C-<right>") #'partial-scroll-left)
  (define-key vterm-mode-map (kbd "S-<up>") #'scroll-up-page-place)
  (define-key vterm-mode-map (kbd "S-<down>") #'scroll-down-page-place)
  (define-key vterm-mode-map (kbd "S-<left>") #'scroll-right-one-column)
  (define-key vterm-mode-map (kbd "S-<right>") #'scroll-left-one-column))

;; Keep eat as fallback (uncomment if vterm has issues)
;; (use-package eat
;;   :ensure t
;;   :defer t)

;; Install and configure claude-code-ide
;; Manually installed in ~/.emacs.d/vendor/claude-code-ide
(use-package claude-code-ide
  :demand t
  :custom
  ;; Terminal backend configuration (vterm - native C, faster)
  (claude-code-ide-terminal-backend 'vterm)  ; Native module, much faster

  ;; Window placement and size
  (claude-code-ide-window-side 'bottom)      ; Which side: left, right, top, bottom
  (claude-code-ide-window-width 90)          ; Width in columns (for left/right)
  (claude-code-ide-window-height 35)         ; Height in lines (for top/bottom)
  (claude-code-ide-focus-on-open t)          ; Focus Claude window when opened

  ;; MCP Integration - ENABLED (auto = all emacs-tools)
  (claude-code-ide-mcp-allowed-tools 'auto)  ; Enable all MCP emacs-tools

  ;; Optional: Append custom system prompt
  (claude-code-ide-system-prompt-append nil) ; Set to string to add context

  :config
  ;; MCP tools are automatically enabled with 'auto setting
  ;; Available tools: xref, tree-sitter, imenu, project, diagnostics
  (message "[Claude Code IDE] MCP tools enabled with auto configuration")

  ;; MCP tools are loaded from claude-code-ide-emacs-tools.el
  ;; and include: xref-find-definitions, tree-sitter parsing,
  ;; imenu symbol navigation, project info, and diagnostics

  :init
  ;; Define prefix keymap for C-c a (claude-ai prefix)
  (define-prefix-command 'claude-ai-map)
  (global-set-key (kbd "C-c a") 'claude-ai-map)

  :bind
  ;; Bind commands to the prefix map
  (:map claude-ai-map
   ("m" . claude-code-ide-menu)        ; C-c a m - Main menu (transient)
   ("c" . claude-code-ide)             ; C-c a c - Start Claude for current project
   ("s" . claude-code-ide-send-prompt) ; C-c a s - Send prompt from minibuffer
   ("r" . claude-code-ide-continue)    ; C-c a r - Resume/continue conversation
   ("l" . claude-code-ide-list-sessions) ; C-c a l - List all active sessions
   ("t" . claude-code-ide-toggle)      ; C-c a t - Toggle window visibility
   ("k" . claude-code-ide-stop)))      ; C-c a k - Stop current session

;; Optional: Customize system prompt for your workflow
;; Uncomment and modify to add project-specific context
;; (setq claude-code-ide-system-prompt-append
;;       "\n\nAdditional context:\n- This is a Clojure/Emacs Lisp project\n- Use functional programming patterns")

(message "[Personal Config] Claude Code IDE with MCP integration loaded")

(provide 'my_claude_code_ide)
;;; my_claude_code_ide.el ends here
