#!/usr/bin/env bash
#
# optimize-start.sh - Quick start script for Emacs Prelude optimization
#
# Usage: cd ~/.emacs.d/personal && bash optimize-start.sh
#

set -e

PERSONAL_DIR="${HOME}/.emacs.d/personal"
ARCHIVE_DIR="${PERSONAL_DIR}/archive-$(date +%Y%m%d)"
BACKUP_FILE="${HOME}/.emacs.d.backup-$(date +%Y%m%d).tar.gz"

echo "================================================================"
echo "Emacs Prelude Optimization - Quick Start"
echo "================================================================"
echo

# Check we're in the right directory
if [ ! -f "${PERSONAL_DIR}/dot_emacs.el" ]; then
    echo "ERROR: Run this from ~/.emacs.d/personal/"
    exit 1
fi

echo "Step 1: Create backup"
echo "------------------------------------------------------------"
if [ -f "${BACKUP_FILE}" ]; then
    echo "Backup already exists: ${BACKUP_FILE}"
else
    echo "Creating backup: ${BACKUP_FILE}"
    tar czf "${BACKUP_FILE}" -C "${HOME}" .emacs.d/
    echo "✓ Backup created"
fi
echo

echo "Step 2: Initialize git (if not already done)"
echo "------------------------------------------------------------"
cd "${HOME}/.emacs.d"
if [ ! -d .git ]; then
    git init
    git add -A
    git commit -m "Initial commit before optimization"
    echo "✓ Git repository initialized"
else
    echo "✓ Git already initialized"
fi
echo

echo "Step 3: Create archive directory"
echo "------------------------------------------------------------"
mkdir -p "${ARCHIVE_DIR}"
echo "✓ Created: ${ARCHIVE_DIR}"
echo

echo "Step 4: Analyze current configuration"
echo "------------------------------------------------------------"
echo "Current personal/*.el files:"
ls -lh "${PERSONAL_DIR}"/*.el 2>/dev/null | awk '{print "  ", $9, "("$5")"}'
echo
echo "Line counts:"
wc -l "${PERSONAL_DIR}"/*.el 2>/dev/null | tail -1 | awk '{print "  Total:", $1, "lines"}'
echo

echo "Step 5: Check loaded modules"
echo "------------------------------------------------------------"
grep "^(require 'prelude-" "${PERSONAL_DIR}/prelude-modules.el" 2>/dev/null | wc -l | \
    awk '{print "  Currently loading:", $1, "modules"}'
echo

echo "Step 6: Benchmark current startup time"
echo "------------------------------------------------------------"
echo "Measuring startup time (this may take a few seconds)..."
STARTUP_TIME=$(emacs --batch --eval '(message "%s" (emacs-init-time))' 2>&1 | grep -oE '[0-9]+\.[0-9]+')
echo "  Current startup time: ${STARTUP_TIME} seconds"
echo

echo "================================================================"
echo "Analysis Complete!"
echo "================================================================"
echo
echo "Next Steps:"
echo
echo "1. Review the optimization plan:"
echo "   Open: ${PERSONAL_DIR}/OPTIMIZATION_PLAN.md"
echo
echo "2. Study the migration examples:"
echo "   Open: ${PERSONAL_DIR}/MIGRATION_EXAMPLES.el"
echo
echo "3. Recommended order:"
echo "   a) First, reduce modules in prelude-modules.el"
echo "   b) Then, refactor dot_emacs.el into organized files"
echo "   c) Finally, implement performance optimizations"
echo
echo "4. Quick wins (do these first):"
echo
echo "   # Reduce loaded modules (safe to test):"
echo "   emacs ${PERSONAL_DIR}/prelude-modules.el"
echo
echo "   # Comment out languages you don't use, then restart Emacs"
echo "   # If something breaks, just uncomment and restart"
echo
echo "5. Rollback if needed:"
echo "   tar xzf ${BACKUP_FILE} -C ${HOME}"
echo
echo "6. Measure improvement:"
echo "   emacs --batch --eval '(message \"%s\" (emacs-init-time))'"
echo
echo "================================================================"
echo

# Create a quick reference card
cat > "${PERSONAL_DIR}/QUICK_REFERENCE.md" << 'EOF'
# Emacs Optimization Quick Reference

## Benchmark Commands

```elisp
;; In Emacs, run these to measure performance:

;; 1. Check startup time
(emacs-init-time)

;; 2. Count loaded features
(length features)

;; 3. List loaded packages
(length package-activated-list)

;; 4. Profile CPU during startup
(require 'profiler)
(profiler-start 'cpu)
;; ... restart Emacs ...
(profiler-report)

;; 5. Find slow packages
M-x esup
```

## Safe Optimization Steps

### Week 1: Module Reduction (SAFEST)

1. Open: `~/.emacs.d/personal/prelude-modules.el`
2. Comment out 50% of language modules
3. Restart Emacs
4. If something breaks, uncomment and restart
5. After 2 days, remove what you didn't miss

Example:
```elisp
;; Keep:
(require 'prelude-emacs-lisp)
(require 'prelude-clojure)

;; Try commenting:
;; (require 'prelude-haskell)  ; Do you use Haskell?
;; (require 'prelude-scala)    ; Do you use Scala?
```

### Week 2: Defer Package Loading

Replace eager loading with lazy loading:

```elisp
;; BEFORE:
(require 'some-package)

;; AFTER:
(use-package some-package
  :defer t
  :hook (some-mode . some-package-mode))
```

### Week 3: Organize Config Files

Create numbered files for easy ordering:
- `00-performance.el` - loaded first
- `01-keybindings.el`
- `02-ui.el`
- `10-clojure.el`
- `90-claude-ide.el` - loaded last

## Rollback Plan

```bash
# Full rollback
tar xzf ~/.emacs.d.backup-YYYYMMDD.tar.gz -C ~/

# Or with git
cd ~/.emacs.d
git reset --hard HEAD~1
```

## Target Metrics

- Startup time: < 2 seconds
- Loaded modules: 6-8 (from 21)
- Active config: ~300 LOC (from ~1000)

## Warning Signs

If you see these, rollback and review:
- Emacs won't start
- Error: "Cannot find feature X"
- Missing syntax highlighting
- Company/Helm not working

## Support

- Read: `OPTIMIZATION_PLAN.md` for detailed steps
- Study: `MIGRATION_EXAMPLES.el` for patterns
- Test: One change at a time
- Commit: After each successful change
EOF

echo "✓ Created: ${PERSONAL_DIR}/QUICK_REFERENCE.md"
echo
echo "Happy optimizing! Start with the QUICK_REFERENCE.md for safest steps."
echo
