# Building and Using vterm in Emacs

**Date**: May 6, 2026  
**System**: macOS (Darwin 23.6.0)  
**Emacs**: 30.1

## Current Status

- ✅ cmake installed (4.3.2)
- ✅ libtool installed (Homebrew)
- ✅ vterm package installed
- ❌ Native module NOT compiled yet
- ❌ libvterm NOT installed

## Why vterm over eat?

| Feature | vterm | eat |
|---------|-------|-----|
| Performance | Faster (native C) | Slower (elisp) |
| Compatibility | 99% terminal apps | 95% terminal apps |
| Installation | Requires compilation | Pure elisp |
| Maintenance | Stable, mature | Newer, evolving |
| Color support | 24-bit true color | 24-bit true color |
| Clipboard | Full integration | Full integration |

**Bottom line**: vterm is faster and more compatible, worth the build effort.

## Installation Steps

### Step 1: Install libvterm (Required Dependency)

```bash
# Install via Homebrew
brew install libvterm

# Verify installation
brew list libvterm
```

### Step 2: Build the vterm Native Module

```bash
# Navigate to vterm directory
cd ~/.emacs.d/elpa/vterm-20260406.134

# Clean any previous build attempts
rm -rf build
mkdir build
cd build

# Configure with CMake
cmake ..

# Build the module
make

# Verify the compiled module exists
ls -lh vterm-module.so 2>/dev/null || ls -lh vterm-module.dylib 2>/dev/null
```

Expected output: You should see `vterm-module.so` or `vterm-module.dylib` (~200KB)

### Step 3: Test vterm in Emacs

```elisp
;; In Emacs, evaluate (M-x eval-expression or M-:)
(require 'vterm)

;; If no error, try opening a vterm buffer
M-x vterm
```

If you see a terminal, it works! Try running:
```bash
ls --color=auto
echo $TERM  # Should show "xterm-256color"
```

### Step 4: Update Claude Code IDE Configuration

Edit: `~/.emacs.d/personal/my_claude_code_ide.el`

```elisp
;; BEFORE (line 44):
(claude-code-ide-terminal-backend 'eat)  ; Pure elisp, easier setup

;; AFTER:
(claude-code-ide-terminal-backend 'vterm)  ; Native C, faster
```

### Step 5: Update Dependencies in Configuration

```elisp
;; In my_claude_code_ide.el, around line 21-36

;; BEFORE:
(use-package eat
  :ensure t
  :defer t)

;; AFTER (or add both if you want to keep eat as fallback):
(use-package vterm
  :ensure t
  :defer t
  :custom
  (vterm-max-scrollback 10000)
  (vterm-buffer-name-string "vterm: %s"))

;; Optional: Keep eat as fallback
(use-package eat
  :ensure t
  :defer t)
```

### Step 6: Restart Emacs and Test

```bash
# Restart Emacs
# Then test Claude Code IDE
M-x claude-code-ide

# The terminal should now use vterm backend
```

## Troubleshooting

### Issue: "Cannot find libvterm"

**Solution**:
```bash
# Check if libvterm is in the expected location
brew --prefix libvterm

# If installed but CMake can't find it, set the path explicitly:
cd ~/.emacs.d/elpa/vterm-*/build
cmake -DLIBVTERM_INCLUDE_DIR=$(brew --prefix libvterm)/include \
      -DLIBVTERM_LIBRARY=$(brew --prefix libvterm)/lib/libvterm.dylib \
      ..
make
```

### Issue: "cmake: command not found"

**Solution**:
```bash
brew install cmake
```

### Issue: Build succeeds but vterm won't load in Emacs

**Check module path**:
```elisp
;; In Emacs
(locate-library "vterm")
;; Should show: ~/.emacs.d/elpa/vterm-YYYYMMDD.NNN/vterm.el

;; Check if module exists
(file-exists-p (expand-file-name "vterm-module.so" 
                 (file-name-directory (locate-library "vterm"))))
```

**Solution**: The module might be in `build/` subdirectory. Copy it:
```bash
cd ~/.emacs.d/elpa/vterm-20260406.134
cp build/vterm-module.so . || cp build/vterm-module.dylib .
```

### Issue: "Wrong type argument: stringp, nil" when loading vterm

**Cause**: vterm-module not found

**Solution**: Rebuild and ensure the module is in the right location:
```bash
cd ~/.emacs.d/elpa/vterm-*/build && make && cp vterm-module.* ..
```

### Issue: vterm works but Claude Code IDE still uses eat

**Check configuration**:
```elisp
;; In Emacs, evaluate:
claude-code-ide-terminal-backend
;; Should return: vterm

;; If it returns eat, you need to:
;; 1. Edit my_claude_code_ide.el
;; 2. Change 'eat to 'vterm
;; 3. Restart Emacs (or M-x eval-buffer in my_claude_code_ide.el)
```

## Advanced Configuration

### Optimize vterm Performance

Add to `my_claude_code_ide.el` or a separate config file:

```elisp
(use-package vterm
  :ensure t
  :defer t
  :custom
  ;; Scrollback buffer size (default: 1000)
  (vterm-max-scrollback 10000)
  
  ;; Buffer naming
  (vterm-buffer-name-string "vterm: %s")
  
  ;; Faster scrolling
  (vterm-timer-delay 0.01)
  
  ;; Kill buffer when process exits
  (vterm-kill-buffer-on-exit t)
  
  ;; Don't query when killing vterm buffer
  (vterm-always-compile-module t)
  
  :config
  ;; Keybindings in vterm mode
  (define-key vterm-mode-map (kbd "C-c C-c") 'vterm-send-C-c)
  (define-key vterm-mode-map (kbd "C-c C-d") 'vterm-send-C-d)
  
  ;; Copy mode for easier text selection
  (define-key vterm-mode-map (kbd "C-c C-t") 'vterm-copy-mode))
```

### vterm Copy Mode

vterm has a special "copy mode" for text selection:
- `C-c C-t`: Toggle copy mode (like tmux copy mode)
- In copy mode: use normal Emacs navigation/selection
- `RET`: Copy selected text and return to terminal mode

## Comparison: eat vs vterm

### When to use vterm:
- ✅ Need maximum compatibility (running complex TUI apps)
- ✅ Want best performance (large outputs, fast scrolling)
- ✅ Okay with compilation step
- ✅ Claude Code IDE integration (recommended)

### When to use eat:
- ✅ Don't want to compile native modules
- ✅ Simpler installation (pure elisp)
- ✅ Good enough for basic terminal usage
- ✅ Contributing to newer elisp-only project

## Verification Checklist

After setup, verify everything works:

```bash
# 1. Check vterm module exists
ls ~/.emacs.d/elpa/vterm-*/vterm-module.* | grep -v "\.c$\|\.h$"

# 2. In Emacs, test vterm
M-x vterm
# Should open a terminal

# 3. Test colors
ls --color=auto

# 4. Test interactive apps
htop  # Should render correctly
# Press 'q' to quit

# 5. Test Claude Code IDE
M-x claude-code-ide
# Terminal should use vterm backend
```

## Maintenance

### Updating vterm

When Emacs updates the vterm package:

```bash
# After package update via M-x list-packages
cd ~/.emacs.d/elpa/vterm-*  # Use tab completion for new version
mkdir -p build && cd build
cmake ..
make
```

Or configure automatic compilation:

```elisp
(setq vterm-always-compile-module t)
```

### Performance Monitoring

```elisp
;; Check if vterm is using native module
(featurep 'vterm-module)  ; Should return t

;; Benchmark terminal output
(benchmark-run 1
  (with-current-buffer (vterm)
    (vterm-send-string "seq 1 1000\n")))
```

## Rollback to eat

If vterm doesn't work for any reason:

```elisp
;; In my_claude_code_ide.el
(claude-code-ide-terminal-backend 'eat)  ; Switch back
```

Restart Emacs. eat is always available as fallback.

## Resources

- [vterm GitHub](https://github.com/akermu/emacs-libvterm)
- [vterm Wiki](https://github.com/akermu/emacs-libvterm/wiki)
- [Claude Code IDE Docs](https://github.com/anthropics/claude-code-ide)

## Quick Reference

```bash
# Install dependency
brew install libvterm

# Build vterm module
cd ~/.emacs.d/elpa/vterm-*/build && cmake .. && make

# Test in Emacs
M-x vterm

# Configure Claude Code IDE
# Edit: ~/.emacs.d/personal/my_claude_code_ide.el
# Change: (claude-code-ide-terminal-backend 'vterm)
```

That's it! vterm should now be faster and more compatible than eat.
