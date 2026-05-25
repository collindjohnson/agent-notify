#!/bin/bash

# macOS notification helpers.

get_homebrew_terminal_notifier_app() {
    local terminal_notifier_path="${1:-}"
    local prefix app_path

    [[ -n "$terminal_notifier_path" ]] || return 1

    case "$terminal_notifier_path" in
        /opt/homebrew/*|/usr/local/*)
            ;;
        *)
            return 1
            ;;
    esac

    for prefix in /opt/homebrew /usr/local; do
        app_path="$prefix/opt/terminal-notifier/terminal-notifier.app"
        if [[ -d "$app_path" ]]; then
            printf '%s\n' "$app_path"
            return 0
        fi
    done

    return 1
}

send_terminal_notifier() {
    local terminal_notifier_path app_path

    terminal_notifier_path="$(command -v terminal-notifier 2>/dev/null || true)"
    [[ -n "$terminal_notifier_path" ]] || return 127

    # On recent macOS builds, directly executing Homebrew's app binary can crash
    # before Notification Center accepts the request. LaunchServices preserves
    # the app identity and allows banners to display.
    if [[ "$(uname -s)" == "Darwin" ]] && [[ -x /usr/bin/open ]]; then
        app_path="$(get_homebrew_terminal_notifier_app "$terminal_notifier_path" || true)"
        if [[ -n "$app_path" ]]; then
            /usr/bin/open -n "$app_path" --args "$@"
            return $?
        fi
    fi

    terminal-notifier "$@"
}
