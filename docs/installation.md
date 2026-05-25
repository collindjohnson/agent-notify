# Agent-Notify Installation Guide

> This guide is designed for both humans and LLM agents. If you're an AI agent, follow the automated steps below.

## Quick Overview

Agent-Notify adds desktop notifications to Claude Code, Codex, and Gemini CLI. You'll get alerts when:

- Tasks complete
- Claude or Gemini needs your input
- Voice announcements (macOS)

Codex currently exposes completion notifications through its `notify` hook. Approval and `request_permissions` prompts do not currently trigger Agent-Notify through Codex.

Supported upgrade paths also repair stale `claude-notify`-style Claude hooks automatically when they are detected.

## For LLM Agents

Execute these commands to install agent-notify:

```bash
# 1. Clone the repository
git clone https://github.com/collindjohnson/agent-notify.git /tmp/agent-notify

# 2. Run the installer
chmod +x /tmp/agent-notify/scripts/install.sh
/tmp/agent-notify/scripts/install.sh

# 3. Reload shell
exec $SHELL

# 4. Enable notifications
an on

# 5. Test it works
an test

# 6. Clean up
rm -rf /tmp/agent-notify
```

### Verify Installation

After installation, confirm these work:

```bash
an version    # Should show: agent-notify version X.X.X
an status     # Should show: Global notifications: ENABLED
an test       # Should trigger a desktop notification
```

### Enable Voice (macOS only)

```bash
an voice on   # Follow prompts to select a voice
an test       # Should hear + see notification
```

### Project-Specific Setup

To enable notifications for a specific project only:

```bash
cd /path/to/your/project
anp on        # Enable for this project
anp status    # Verify
```

If Claude Code has not trusted the project yet, `anp on` will warn that Claude may ignore project settings until the trust prompt is accepted.

### Troubleshooting

If `an` command not found:

```bash
# Add to PATH
export PATH="$HOME/.local/bin:$PATH"
# Or reload shell
exec $SHELL
```

If notifications don't appear:

```bash
# macOS: Install terminal-notifier for better notifications
brew install terminal-notifier

# Check status
an status
```

### Configuration Files

After installation, these files are created:

- `~/.agent-notify/` - Main installation directory
- `~/.claude/settings.json` - Hook configuration on the default Claude Code path
- `~/.config/.claude/settings.json` - Hook configuration on some Windows Claude Code setups
- `~/.claude/notifications/voice-enabled` - Voice setting (if enabled)

### Uninstallation

```bash
# Disable notifications first
an off

# Remove installation
rm -rf ~/.agent-notify
rm -f ~/.local/bin/an ~/.local/bin/anp ~/.local/bin/agent-notify
rm -rf ~/.claude/notifications
```

---

## For Humans

### macOS (Homebrew) - Recommended

```bash
brew tap collindjohnson/agent-notify https://github.com/collindjohnson/agent-notify && brew install agent-notify && an on
```

### Linux / WSL

```bash
curl -sSL https://raw.githubusercontent.com/collindjohnson/agent-notify/main/scripts/install.sh | bash
exec $SHELL
an on
```

### npm (macOS / Linux / Windows)

```bash
npm install -g agent-notify
an on
```

### macOS Embedded Terminals

If clicking a notification opens `Terminal.app` instead of your editor or IDE terminal, add a click-through mapping:

```bash
an click-through add PhpStorm
an test
```

### Manual Installation

```bash
git clone https://github.com/collindjohnson/agent-notify.git
cd agent-notify
./scripts/install.sh
```

### Quick Commands

| Command       | What it does                    |
| ------------- | ------------------------------- |
| `an on`       | Enable notifications            |
| `an off`      | Disable notifications           |
| `an test`     | Send test notification          |
| `an status`   | Check current status            |
| `an update`   | Update agent-notify              |
| `an update check` | Check the latest release and show the update command |
| `an voice on` | Enable voice (macOS)            |
| `anp on`      | Enable for current project only |

That's it! You'll now get notified when Claude Code completes tasks.
