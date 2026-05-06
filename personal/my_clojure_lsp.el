;; clojure-lsp
;; see https://emacs-lsp.github.io/lsp-mode/tutorials/clojure-guide/
;; and https://clojure-lsp.github.io/clojure-lsp/clients/#emacs

;; ensure the lsp-mode package is installed

(add-hook 'clojure-mode-hook 'lsp)
(add-hook 'clojurescript-mode-hook 'lsp)
(add-hook 'clojurec-mode-hook 'lsp)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.2
      lsp-headerline-breadcrumb-enable t
      company-minimum-prefix-length 1
      lsp-lens-enable t
      lsp-ui-doc-enable t
      lsp-file-watch-threshold 10000
      lsp-ui-sideline-enable t
      lsp-signature-auto-activate nil
      lsp-clojure-server-command '("/usr/local/bin/clojure-lsp")
      lsp-diagnostics-provider :none
      lsp-enable-indentation nil ;; use cider indentation instead of lsp
      ;; lsp-enable-completion-at-point nil ;; uncomment to use cider completion instead of lsp
      )
