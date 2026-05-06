# Claude Code IDE Setup Instructions

This personal module configures claude-code-ide with MCP server integration.

## Prerequisites

### 1. Install Claude Code CLI

First, ensure Claude Code CLI is installed and in your PATH:

```bash
# Check if claude is installed
which claude

# If not installed, follow instructions at:
# https://github.com/anthropics/claude-code
```

### 2. Terminal Backend

The module uses `vterm` as the terminal backend. Vterm is a native C module compiled for ARM64 architecture, providing high-performance terminal emulation.

**ARM64 libvterm**: Custom-built and installed to `~/.local/lib/` for native Apple Silicon performance.

## Installation Status

✅ **Already installed!** The package has been cloned to:
```
~/.emacs.d/vendor/claude-code-ide
```

The module automatically adds this to your load-path and configures everything.

Just **restart Emacs** and the `eat` terminal package will be auto-installed from MELPA (no compilation required!).

## Configuration

The module is located at: `/Users/cue/.emacs.d/personal/my_claude_code_ide.el`

### Key Settings

- **MCP Integration**: Enabled (`claude-code-ide-mcp-allowed-tools 'auto`)
- **Terminal Backend**: vterm (ARM64 native, high performance)
- **Window Layout**: Bottom window, 35 lines tall
- **Auto-focus**: Enabled

### Keybindings

All keybindings use the `C-c a` prefix:

| Keybinding | Command | Description |
|------------|---------|-------------|
| `C-c a m` | `claude-code-ide-menu` | Open main menu (transient) |
| `C-c a c` | `claude-code-ide` | Start Claude for current project |
| `C-c a s` | `claude-code-ide-send-prompt` | Send prompt from minibuffer |
| `C-c a r` | `claude-code-ide-continue` | Resume conversation |
| `C-c a l` | `claude-code-ide-list-sessions` | List all sessions |
| `C-c a t` | `claude-code-ide-toggle` | Toggle window visibility |
| `C-c a k` | `claude-code-ide-stop` | Stop current session |

## MCP Tools Enabled

With MCP integration enabled, Claude can directly access:

- **xref**: Find symbol definitions and references via LSP
- **tree-sitter**: Syntax analysis and AST navigation
- **imenu**: Symbol listing and navigation
- **project**: Project-aware operations (find files, grep, etc.)

## Customization

Edit `/Users/cue/.emacs.d/personal/my_claude_code_ide.el` to customize:

### Add Custom System Prompt

```elisp
(setq claude-code-ide-system-prompt-append
      "Project context:\n- Clojure/Emacs Lisp codebase\n- Prefer functional patterns")
```

### Customize MCP Tools

Control which tools are available:

```elisp
;; Enable all emacs-tools (default)
(setq claude-code-ide-mcp-allowed-tools 'auto)

;; Or specify particular tools
(setq claude-code-ide-mcp-allowed-tools '("xref" "imenu" "project"))

;; Or use a custom pattern
(setq claude-code-ide-mcp-allowed-tools "emacs-tools/*")

;; Or disable MCP tools
(setq claude-code-ide-mcp-allowed-tools nil)
```

### Change Window Position

```elisp
;; Change from bottom to right side
(setq claude-code-ide-window-side 'right)

;; Adjust width (columns) for left/right positioning
(setq claude-code-ide-window-width 100)

;; Adjust height (lines) for top/bottom positioning
(setq claude-code-ide-window-height 40)
```

### Change Terminal Backend

Currently using `vterm` (ARM64 native). To switch to `eat` (pure elisp, no compilation):

```elisp
(setq claude-code-ide-terminal-backend 'eat)
;; Then install eat: M-x package-install RET eat RET
```

## Usage

1. **Start Claude**: `C-c a c` or `M-x claude-code-ide`
2. **Toggle Window**: `C-c a t` to show/hide the Claude window (keeps session alive)
3. **Send Prompt**: `C-c a s` or type directly in the Claude window
4. **Multi-Project**: Each project gets its own session automatically
5. **Stop Session**: `C-c a k` or close the window

## Troubleshooting

### Claude CLI Not Found

```elisp
;; Check PATH in Emacs
M-x getenv RET PATH

;; If claude is not in PATH, add to personal/preload/path.el:
(setenv "PATH" (concat "/path/to/claude/bin:" (getenv "PATH")))
(setq exec-path (cons "/path/to/claude/bin" exec-path))
```

### vterm ARM64 Installation

vterm is already installed and compiled for ARM64 architecture with a custom-built libvterm.

**Installation details**:
- **libvterm location**: `~/.local/lib/libvterm.0.dylib` (ARM64)
- **vterm module**: `~/.emacs.d/elpa/vterm-*/vterm-module.so` (ARM64)
- **Architecture**: Native Apple Silicon (arm64)

If you need to rebuild vterm:
```bash
cd ~/.emacs.d/elpa/vterm-*
rm -rf build vterm-module.so
mkdir build && cd build
cmake -DCMAKE_OSX_ARCHITECTURES=arm64 -DCMAKE_PREFIX_PATH=~/.local ..
make
```

### MCP Tools Not Working

1. Ensure `claude-code-ide-mcp-allowed-tools` is set to `'auto`
2. Check Claude CLI version supports MCP (v2.0+)
3. Check `*Messages*` buffer for MCP-related errors

## Resources

- Claude Code IDE: https://github.com/emacsmirror/claude-code-ide
- Claude Code CLI: https://github.com/anthropics/claude-code
- MCP Protocol: Model Context Protocol documentation
