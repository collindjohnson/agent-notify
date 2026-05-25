#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

fail() {
    echo "FAIL: $1"
    exit 1
}

test_dir="$(mktemp -d)"
trap 'rm -rf "$test_dir"' EXIT

export HOME="$test_dir/home"
export CLAUDE_HOME="$HOME/.claude"
export CURSOR_NOTIFY_WRAPPER="$HOME/.local/bin/cursor-notify"
fake_bin="$test_dir/bin"
notify_log="$test_dir/notify.log"

mkdir -p "$fake_bin" "$HOME/.claude/notifications"

cat > "$fake_bin/cursor" <<'EOF'
#!/bin/bash
if [[ "${1:-}" == "agent" && "${2:-}" == "--help" ]]; then
    echo "Cursor Agent help"
    exit 0
fi
echo "cursor:$*" >> "$CURSOR_TEST_LOG"
exit "${CURSOR_TEST_EXIT:-0}"
EOF
chmod +x "$fake_bin/cursor"

cat > "$test_dir/notifier.sh" <<'EOF'
#!/bin/bash
echo "$*" >> "$CURSOR_NOTIFY_TEST_LOG"
EOF
chmod +x "$test_dir/notifier.sh"

export PATH="$fake_bin:/usr/bin:/bin:/usr/sbin:/sbin"
export CURSOR_TEST_LOG="$test_dir/cursor.log"
export CURSOR_NOTIFY_TEST_LOG="$notify_log"
export CURSOR_NOTIFY_PROJECT="demo"

source "$SCRIPT_DIR/../lib/code-notify/utils/colors.sh"
source "$SCRIPT_DIR/../lib/code-notify/utils/detect.sh"
source "$SCRIPT_DIR/../lib/code-notify/core/config.sh"

get_notify_script() {
    printf '%s\n' "$test_dir/notifier.sh"
}

detect_cursor_agent >/dev/null || fail "Cursor Agent detection failed"

enable_cursor_hooks || fail "enable_cursor_hooks failed"
[[ -x "$CURSOR_NOTIFY_WRAPPER" ]] || fail "cursor-notify wrapper was not created"
is_cursor_enabled || fail "is_cursor_enabled did not detect the managed wrapper"

"$CURSOR_NOTIFY_WRAPPER" --mode ask "hello" >/dev/null
grep -q '^cursor:agent --mode ask hello$' "$CURSOR_TEST_LOG" || fail "wrapper did not call cursor agent"
grep -q '^stop cursor demo$' "$notify_log" || fail "wrapper did not send success notification"

: > "$notify_log"
CURSOR_TEST_EXIT=7 "$CURSOR_NOTIFY_WRAPPER" "fail now" >/dev/null 2>&1 && fail "wrapper did not preserve failure exit"
grep -q '^error cursor demo$' "$notify_log" || fail "wrapper did not send failure notification"

disable_cursor_hooks || fail "disable_cursor_hooks failed"
[[ ! -e "$CURSOR_NOTIFY_WRAPPER" ]] || fail "managed cursor-notify wrapper was not removed"

echo "PASS: Cursor wrapper enable/disable and notifications"
