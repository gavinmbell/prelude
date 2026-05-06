# Emacs Prelude Optimization Plan

## Analysis Summary
- **Configuration Files**: 15 personal config files
- **Loaded Modules**: 21 language modules
- **Package Directory Size**: 76MB
- **Emacs Version**: 30.1
- **Current Issues**: Redundancy, conflicts, unused code

## Recommended Actions (Prioritized)

### Phase 1: Configuration Consolidation (High Impact)

#### 1.1 Archive Old dot_emacs.el
**Current State**: `dot_emacs.el` contains 469 lines, mostly legacy/commented code  
**Action**: Extract only actively used settings, archive the rest  
**Impact**: Reduce personal config load time by ~40%  
**Files**: 
- `/Users/cue/.emacs.d/personal/dot_emacs.el`

**Extract These Active Settings**:
- Lines 18-30: Mac modifier keys configuration
- Lines 49-50: ns-auto-titlebar setup
- Lines 64-66: Helm keybindings
- Lines 85-119: Aggressive indent + DAP configuration
- Lines 310-340: SQL connections (if actively used)
- Lines 408: whitespace-style override
- Lines 412-418: zenburn theme customization
- Lines 433-443: Mac keyboard setup

**Archive**: Everything else (commented code, old configs)

#### 1.2 Consolidate Keybindings
**Current State**: Keybindings scattered across 3 files (keys.el, misc.el, dot_emacs.el)  
**Action**: Create single `personal/00-keybindings.el` (00- prefix ensures early loading)  
**Impact**: Better organization, easier maintenance

#### 1.3 Module Audit
**Current State**: Loading 21 language modules  
**Action**: Keep only languages you actively use  
**Impact**: Reduce startup time by 30-50%

**Recommended Core Set** (based on your work):
```elisp
;; Core utilities
(require 'prelude-helm)
(require 'prelude-helm-everywhere)
(require 'prelude-company)

;; Languages you actively use (adjust based on your needs)
(require 'prelude-emacs-lisp)    ; Always needed for Emacs config
(require 'prelude-clojure)       ; You have clojure hooks
(require 'prelude-lsp)           ; LSP support
(require 'prelude-org)           ; Org-mode

;; Add only if you actively code in these:
;; (require 'prelude-go)
;; (require 'prelude-python)
;; (require 'prelude-rust)
```

### Phase 2: Code Quality (Medium Impact)

#### 2.1 Fix Deprecated Code
**Issue**: Using `flet` which was removed in Emacs 27+  
**Location**: `dot_emacs.el:327`  
**Fix**: Replace with `cl-letf` or refactor

#### 2.2 Remove Hardcoded Credentials
**Issue**: SQL passwords in plain text  
**Location**: `dot_emacs.el:268-336`  
**Fix**: Use auth-source or environment variables

#### 2.3 Whitespace Management
**Issue**: Conflicting whitespace settings  
**Current**:
```elisp
(setq prelude-whitespace nil)          ; Disables Prelude's management
(setq whitespace-style '(...))         ; But configures it anyway
```
**Fix**: Choose one approach:
- **Option A**: Use Prelude's whitespace (remove line 408, keep line 61)
- **Option B**: Fully disable (remove both, manage manually)

### Phase 3: Performance (Medium Impact)

#### 3.1 Lazy Load Heavy Packages
**Current**: Many packages load eagerly  
**Recommended Pattern**:
```elisp
(use-package aggressive-indent
  :defer t
  :hook (clojure-mode . aggressive-indent-mode)
  :diminish)

(use-package dap-mode
  :defer t
  :commands (dap-debug dap-mode))
```

#### 3.2 Optimize GC Settings
**Current**: `gc-cons-threshold 50000000` (50MB) in init.el:99  
**Recommended**: Temporarily increase during startup
```elisp
;; In personal/preload/00-performance.el
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Reset after startup
(add-hook 'emacs-startup-hook
  (lambda ()
    (setq gc-cons-threshold 16777216  ; 16MB
          gc-cons-percentage 0.1)))
```

#### 3.3 Native Compilation
**Check if enabled**:
```elisp
(when (native-comp-available-p)
  (setq native-comp-async-report-warnings-errors nil)
  (setq native-comp-deferred-compilation t))
```

### Phase 4: Cleanup (Low Impact, High Organization)

#### 4.1 Package Cleanup
**Action**: Audit and remove unused packages  
**Command**: `M-x package-autoremove`

#### 4.2 File Organization
**Current Structure**:
```
personal/
├── custom.el
├── dot_emacs.el (469 lines, legacy)
├── keys.el (137 lines)
├── misc.el (219 lines)
├── half-height.el
├── disable-ace-window.el
├── my_claude_code_ide.el
├── my_clojure_lsp.el
└── preload/
    ├── theme.el
    └── ensure-path.el
```

**Recommended Structure**:
```
personal/
├── 00-performance.el       (GC, startup opts)
├── 01-keybindings.el      (All keybindings)
├── 02-ui.el               (Theme, frame, display)
├── 03-editing.el          (Editing behavior)
├── 10-clojure.el          (Clojure-specific)
├── 10-elisp.el            (Elisp-specific)
├── 90-claude-ide.el       (IDE integration)
├── custom.el              (Auto-generated)
└── preload/
    ├── theme.el
    └── ensure-path.el
```

#### 4.3 Archive Unused Code
**Create**: `personal/archive/` directory  
**Move**:
- Commented-out code from dot_emacs.el
- SQL configurations (if unused)
- MUD/MOO code
- Old theme configurations

## Implementation Order

### Week 1: Safety & Backup
1. **Backup current config**: `tar czf ~/.emacs.d.backup-$(date +%Y%m%d).tar.gz ~/.emacs.d/`
2. **Git commit**: Commit current state
3. **Document active workflows**: List what you actually use daily

### Week 2: Module Reduction
1. Comment out 50% of language modules in `prelude-modules.el`
2. Restart Emacs, test for 2 days
3. Remove modules you didn't miss

### Week 3: Configuration Consolidation
1. Create new organized files (00-*, 01-*, etc.)
2. Move settings incrementally
3. Test after each file

### Week 4: Performance Tuning
1. Implement lazy loading
2. Optimize GC settings
3. Benchmark startup time

## Success Metrics

- **Startup time**: Target < 2 seconds (measure with `emacs-init-time`)
- **Module count**: Reduce from 21 to 6-8 core modules
- **Personal config**: Reduce from ~1000 LOC to ~300 LOC of active code
- **Maintainability**: All settings documented and organized

## Benchmarking Commands

```elisp
;; Check startup time
(message "Emacs startup time: %s" (emacs-init-time))

;; Profile init
(require 'profiler)
(profiler-start 'cpu)
;; Restart Emacs
(profiler-report)

;; List all loaded features
(length features)

;; Check package count
(length package-activated-list)
```

## Rollback Plan

If anything breaks:
```bash
cd ~/.emacs.d
git reset --hard HEAD  # If using git
# OR
rm -rf ~/.emacs.d && tar xzf ~/.emacs.d.backup-*.tar.gz
```

## Notes

- Keep `prelude-modules.el` minimal - this is loaded on every startup
- Use `preload/` only for settings needed before Prelude initializes
- Defer everything possible with `:defer t` or `:hook`
- Test incrementally - don't change everything at once
