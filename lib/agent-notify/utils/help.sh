#!/bin/bash

# Shared help text for Agent-Notify

is_macos_help_context() {
    [[ "$(uname -s)" == "Darwin" ]]
}

# Show help message
# Usage: show_help [command_name]
show_help() {
    local cmd_name="${1:-an}"
    cat << EOF
${BOLD}Agent-Notify${RESET} - Desktop notifications for AI coding tools

${BOLD}SUPPORTED TOOLS:${RESET}
    Claude Code, OpenAI Codex, Google Gemini CLI, Cursor Agent

${BOLD}USAGE:${RESET}
    $cmd_name <command> [tool]

${BOLD}COMMANDS:${RESET}
    ${GREEN}on${RESET}              Enable notifications (all detected tools)
    ${GREEN}on${RESET} all          Enable notifications (explicit alias for all detected tools)
    ${GREEN}on${RESET} <tool>       Enable for specific tool (claude/codex/gemini/cursor)
    ${GREEN}off${RESET}             Disable notifications (all tools)
    ${GREEN}off${RESET} all         Disable notifications (explicit alias for all tools)
    ${GREEN}off${RESET} <tool>      Disable for specific tool
    ${GREEN}status${RESET}          Show status for all tools
    ${GREEN}status${RESET} all      Show status for all tools (explicit alias)
    ${GREEN}test${RESET}            Send a test notification
    ${GREEN}update${RESET} [check]  Update agent-notify or check the latest release
    ${GREEN}alerts${RESET} <cmd>    Configure which events trigger alerts
    ${GREEN}voice${RESET} <cmd>     Voice notification commands
EOF

    if is_macos_help_context; then
        cat << EOF
    ${GREEN}click-through${RESET}   Configure which app opens on notification click
EOF
    fi

    cat << EOF
    ${GREEN}setup${RESET}           Run initial setup wizard
    ${GREEN}help${RESET}            Show this help message
    ${GREEN}version${RESET}         Show version information

${BOLD}TOOL NAMES:${RESET}
    ${CYAN}claude${RESET}          Claude Code
    ${CYAN}codex${RESET}           OpenAI Codex CLI
    ${CYAN}gemini${RESET}          Google Gemini CLI
    ${CYAN}cursor${RESET}          Cursor Agent (stop hook + cursor-notify wrapper)

${BOLD}PROJECT COMMANDS:${RESET}
    ${GREEN}project on${RESET}      Enable for current project
    ${GREEN}project off${RESET}     Disable for current project
    ${GREEN}project status${RESET}  Check project status

${BOLD}ALERT TYPES:${RESET}
    ${GREEN}alerts${RESET}              Show current alert type configuration
    ${GREEN}alerts add${RESET} <type>   Add a notification type
    ${GREEN}alerts remove${RESET} <type> Remove a notification type
    ${GREEN}alerts reset${RESET}        Reset to default (idle_prompt only)

    Notification types: ${CYAN}idle_prompt${RESET} (default), ${CYAN}permission_prompt${RESET}, ${CYAN}auth_success${RESET}, ${CYAN}elicitation_dialog${RESET}
    Claude events: ${CYAN}SubagentStart${RESET}, ${CYAN}SubagentStop${RESET}, ${CYAN}TeammateIdle${RESET}, ${CYAN}TaskCreated${RESET}, ${CYAN}TaskCompleted${RESET}
    Note: alert-type matching applies to Claude Code and Gemini CLI hooks.
          Codex currently exposes completion events through its notify payload.

${BOLD}VOICE COMMANDS:${RESET}
    ${GREEN}voice on${RESET}            Enable voice for all tools
    ${GREEN}voice on${RESET} <tool>     Enable voice for specific tool
    ${GREEN}voice off${RESET}           Disable all voice
    ${GREEN}voice off${RESET} <tool>    Disable voice for specific tool
    ${GREEN}voice status${RESET}        Show voice settings

${BOLD}SOUND COMMANDS:${RESET}
    ${GREEN}sound on${RESET}            Enable with default system sound
    ${GREEN}sound off${RESET}           Disable sound notifications
    ${GREEN}sound set${RESET} <path>    Use custom sound file (.wav, .aiff, .mp3, .ogg)
    ${GREEN}sound default${RESET}       Reset to system default
    ${GREEN}sound test${RESET}          Play current sound
    ${GREEN}sound list${RESET}          Show available system sounds
    ${GREEN}sound status${RESET}        Show sound configuration
EOF

    if is_macos_help_context; then
        cat << EOF

${BOLD}CLICK-THROUGH COMMANDS:${RESET}
    ${GREEN}click-through${RESET}              Show current mappings
    ${GREEN}click-through add${RESET} [name]   Add an app mapping
    ${GREEN}click-through remove${RESET}       Interactively remove mappings
    ${GREEN}click-through reset${RESET}        Reset to built-in defaults

    Note: controls which app Agent-Notify activates when you click a macOS notification.
EOF
    fi

    cat << EOF

${BOLD}ALIASES:${RESET}
    ${CYAN}an${RESET}  <command>   Main command
    ${CYAN}anp${RESET} <command>   Shortcut for project commands

${BOLD}EXAMPLES:${RESET}
    an on                   # Enable for all detected tools
    an on all               # Same as an on
    an on claude            # Enable for Claude Code only
    an on cursor            # Install Cursor stop hook and wrapper
    an off                  # Disable all
    an off all              # Same as an off
    an status               # Show status for all tools
    an status all           # Same as an status
    an test                 # Send test notification
    an update check         # Check whether an update is needed and show the update command
    an alerts               # Show alert type config
    an alerts add permission_prompt  # Also notify on permission requests
    an alerts add SubagentStop       # Also notify when Claude subagents finish
    an alerts reset         # Back to idle_prompt only (less noisy)
    an sound on             # Enable notification sounds
    an sound set ~/ding.wav # Use custom sound
EOF

    if is_macos_help_context; then
        cat << EOF
    an click-through        # Show current click-through mappings
    an click-through add    # Add an app mapping
    an click-through remove # Interactively remove mappings
EOF
    fi

    cat << EOF
    anp on                  # Enable for current project

${BOLD}MORE INFO:${RESET}
    ${DIM}https://github.com/collindjohnson/agent-notify${RESET}

EOF
}
