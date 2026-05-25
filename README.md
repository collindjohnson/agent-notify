# Agent-Notify

> **Official downloads**: https://github.com/collindjohnson/agent-notify/releases
>
> **Homebrew**: `brew install collindjohnson/tools/agent-notify`
>
> **npm**: `npm install -g agent-notify`

Desktop notifications for AI coding tools - get alerts when tasks complete or input is needed.

<p>
  <img src="assets/multi-tools-support.png" width="48%" alt="Multi-tool support"/>
  <img src="assets/multi-tools-support-02.png" width="48%" alt="All tools enabled"/>
</p>

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![macOS](https://img.shields.io/badge/macOS-supported-green.svg)](https://www.apple.com/macos)
[![Linux](https://img.shields.io/badge/Linux-supported-green.svg)](https://www.linux.org/)
[![Windows](https://img.shields.io/badge/Windows-supported-green.svg)](https://www.microsoft.com/windows)

---

## Features

- **Multi-tool support** - Claude Code, OpenAI Codex, Google Gemini CLI, Cursor Agent
- **Works everywhere** - Terminal, VSCode, Cursor, or any editor
- **Cross-platform** - macOS, Linux, Windows
- **Native notifications** - Uses system notification APIs
- **macOS click-through control** - Choose which app notification clicks activate
- **Sound notifications** - Play custom sounds on task completion
- **Voice announcements** - Hear when tasks complete (macOS, Windows)
- **Tool-specific messages** - "Claude completed the task", "Codex completed the task"
- **Project-specific settings** - Different configs per project
- **Quick aliases** - `an` and `anp` for fast access

## Installation

### For Humans

**macOS (Homebrew)**

```bash
brew tap collindjohnson/tools
brew install agent-notify
an on
```

**macOS (Homebrew, Already Installed)**

```bash
an update
agent-notify version
```

If you were using the older `claude-notify` hook layout, supported upgrades now repair those Claude hooks automatically. On Windows, that repair also covers older `notify.ps1` hook layouts and alternate Claude settings locations such as `%USERPROFILE%\.config\.claude\settings.json`. Existing unrelated Claude hooks are preserved during enable/disable operations.

**Linux / WSL**

```bash
curl -sSL https://raw.githubusercontent.com/collindjohnson/agent-notify/main/scripts/install.sh | bash
```

**npm (macOS / Linux / Windows)**

```bash
npm install -g agent-notify
an on
```

**Windows**

```powershell
irm https://raw.githubusercontent.com/collindjohnson/agent-notify/main/scripts/install-windows.ps1 | iex
```

### For LLM Agents

Paste this to your AI agent (Claude Code, Cursor, etc.):

```
Install agent-notify by following:
https://raw.githubusercontent.com/collindjohnson/agent-notify/main/docs/installation.md
```

Or fetch directly:

```bash
curl -s https://raw.githubusercontent.com/collindjohnson/agent-notify/main/docs/installation.md
```

## Usage

| Command              | Description                                  |
| -------------------- | -------------------------------------------- |
| `an on`              | Enable notifications for all detected tools  |
| `an on all`          | Explicit alias for enabling all detected tools |
| `an on claude`       | Enable for Claude Code only                  |
| `an on codex`        | Enable for Codex only                        |
| `an on gemini`       | Enable for Gemini CLI only                   |
| `an on cursor`       | Install the Cursor Agent notification wrapper |
| `an off`             | Disable notifications                        |
| `an off all`         | Explicit alias for disabling all tools       |
| `an test`            | Send test notification                       |
| `an status`          | Show current status                          |
| `an update`          | Update agent-notify                           |
| `an update check`    | Check the latest release and show the update command |
| `an click-through`   | Show current macOS click-through mappings    |
| `an click-through add <app>` | Add a macOS click-through mapping    |
| `an alerts`          | Configure which events trigger notifications |
| `an sound on`        | Enable sound notifications                   |
| `an sound set <path>`| Use custom sound file                        |
| `an voice on`        | Enable voice (macOS, Windows)                |
| `an voice on claude` | Enable voice for Claude only                 |
| `anp on`             | Enable for current project only              |

When enabling project notifications with `anp on`, Agent-Notify warns if Claude project trust does not appear to be accepted yet.
Project-scoped Claude hooks override the global mute file, so `an off` will not suppress a project where `anp on` is enabled.
`all` is also accepted as an explicit alias for global commands such as `an on all`, `an off all`, and `an status all`.

## How It Works

Agent-Notify uses the hook systems built into AI coding tools:

- **Claude Code**: `~/.claude/settings.json`
- **Codex**: `~/.codex/config.toml`
- **Gemini CLI**: `~/.gemini/settings.json`
- **Cursor Agent**: `~/.local/bin/cursor-notify` wrapper

For Codex, Agent-Notify configures `notify = ["/absolute/path/to/notifier.sh", "codex"]` and reads the JSON payload Codex appends on completion.
Codex currently exposes completion events through `notify`; approval and `request_permissions` prompts do not currently arrive through this hook.

Cursor Agent does not currently expose a hook configuration file. `an on cursor` installs a `cursor-notify` wrapper that runs Cursor Agent and sends a Agent-Notify completion or error notification when the process exits:

```sh
cursor-notify "your prompt"
cursor-notify -p --trust "run tests and summarize"
cursor-notify agent --mode ask "explain this repo"
```

When enabled, it adds hooks that call the notification script when tasks complete:

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [{ "type": "command", "command": "notify.sh stop claude" }]
      }
    ],
    "Notification": [
      {
        "matcher": "idle_prompt",
        "hooks": [
          { "type": "command", "command": "notify.sh notification claude" }
        ]
      }
    ],
    "SubagentStop": [
      {
        "matcher": "",
        "hooks": [
          { "type": "command", "command": "notify.sh SubagentStop claude" }
        ]
      }
    ]
  }
}
```

### Alert Types

<img src="assets/an-status-v1.4.0.png" width="60%" alt="an status showing alert types"/>

By default, notifications only fire when the AI is idle and waiting for input (`idle_prompt`). You can customize this:

```bash
an alerts                          # Show current config
an alerts add permission_prompt    # Also notify on tool permission requests
an alerts add SubagentStop         # Also notify when Claude subagents finish
an alerts remove permission_prompt # Remove permission notifications
an alerts reset                    # Back to default (idle_prompt only)
```

| Type                 | Description                                    |
| -------------------- | ---------------------------------------------- |
| `idle_prompt`        | AI is waiting for your input (default)         |
| `permission_prompt`  | AI needs tool permission (Y/n)                 |
| `auth_success`       | Authentication success                         |
| `elicitation_dialog` | MCP tool input needed                          |
| `SubagentStart`      | Claude subagent started                        |
| `SubagentStop`       | Claude subagent completed                      |
| `TeammateIdle`       | Claude teammate is waiting for input           |
| `TaskCreated`        | Claude agent-team task was created             |
| `TaskCompleted`      | Claude agent-team task completed               |

Alert-type matching applies to Claude Code notification hooks and Gemini CLI notification hooks. Claude Code agent/team events are separate hook events and are opt-in via `an alerts add SubagentStop`, `an alerts add TeammateIdle`, or `an alerts add TaskCompleted`.

Agent-team and subagent workflows can be noisy if `permission_prompt` is enabled. If you only want idle pings, run `an alerts remove permission_prompt && an on`. Codex currently uses completion events from `notify`, so `permission_prompt` and `idle_prompt` settings do not change Codex behavior.

## Troubleshooting

**Command not found?**

```bash
exec $SHELL   # Reload shell
```

**No notifications?**

```bash
an status     # Check if enabled
an test       # Test notification
brew install terminal-notifier  # Better notifications (macOS)
```

**Notification click opens the wrong macOS app?**

```bash
an click-through add PhpStorm
an test
```

**Installed with npm?**

```bash
an update     # Runs: npm install -g agent-notify@latest
```

**Too many `last_notification_*` files in `~/.claude/notifications`?**

Generated rate-limit state files are stored under `~/.claude/notifications/state/` instead of cluttering the root notifications folder.

## Project Structure

```
agent-notify/
├── bin/           # Main executable
├── lib/           # Library code
├── scripts/       # Install scripts
├── docs/          # Documentation
└── assets/        # Images
```

## Links

- [Installation Guide](docs/installation.md)
- [Hook Configuration](docs/HOOKS_GUIDE.md)
- [Contributing](docs/CONTRIBUTING.md)
- [GitHub Issues](https://github.com/collindjohnson/agent-notify/issues)

## License

MIT License - see [LICENSE](LICENSE)
