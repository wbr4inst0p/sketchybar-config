#!/usr/bin/env bash

# Pomodoro timer widget for SketchyBar
#
# Controls:
#   Left click        : start / pause
#   Right click        : reset current cycle (back to a fresh work session)
#   Shift + Left click : skip to the next phase
#
# State is persisted across sketchybar reloads/restarts in $STATE_FILE.

STATE_DIR="$HOME/.cache/sketchybar"
STATE_FILE="$STATE_DIR/pomodoro.state"
mkdir -p "$STATE_DIR"

WORK_SEC=$((25 * 60))
SHORT_BREAK_SEC=$((5 * 60))
LONG_BREAK_SEC=$((15 * 60))
CYCLES_BEFORE_LONG_BREAK=4

# running=0/1 mode=work|short_break|long_break remaining=<seconds> count=<completed pomodoros>
if [ ! -f "$STATE_FILE" ]; then
  echo "running=0 mode=work remaining=$WORK_SEC count=0" > "$STATE_FILE"
fi
# shellcheck disable=SC1090
source "$STATE_FILE"

notify() {
  osascript -e "display notification \"$2\" with title \"$1\"" >/dev/null 2>&1 &
}

save_state() {
  echo "running=$running mode=$mode remaining=$remaining count=$count" > "$STATE_FILE"
}

reset_cycle() {
  mode="work"
  remaining=$WORK_SEC
  running=0
  count=0
}

advance_phase() {
  if [ "$mode" = "work" ]; then
    count=$((count + 1))
    if [ $((count % CYCLES_BEFORE_LONG_BREAK)) -eq 0 ]; then
      mode="long_break"
      remaining=$LONG_BREAK_SEC
      notify "Pomodoro" "Great job! Time for a long break."
    else
      mode="short_break"
      remaining=$SHORT_BREAK_SEC
      notify "Pomodoro" "Work session done. Short break!"
    fi
  else
    mode="work"
    remaining=$WORK_SEC
    notify "Pomodoro" "Break's over. Back to work!"
  fi
}

# Click handling (BUTTON is only set for click_script invocations)
if [ -n "$BUTTON" ]; then
  if [ "$BUTTON" = "right" ]; then
    reset_cycle
  elif [ "$BUTTON" = "left" ]; then
    if [ "$MODIFIER" = "shift" ]; then
      advance_phase
      running=0
    else
      if [ "$running" = "1" ]; then
        running=0
      else
        running=1
      fi
    fi
  fi
elif [ "$SENDER" = "routine" ] && [ "$running" = "1" ]; then
  remaining=$((remaining - 1))
  if [ "$remaining" -le 0 ]; then
    advance_phase
  fi
fi

save_state

minutes=$((remaining / 60))
seconds=$((remaining % 60))
label=$(printf "%02d:%02d" "$minutes" "$seconds")

case "$mode" in
  work) color=0xffff5555 ;;
  short_break) color=0xff50fa7b ;;
  long_break) color=0xff8be9fd ;;
esac

if [ "$running" != "1" ]; then
  label_color=0xff888888
  label="⏸ $label"
else
  label_color=$color
fi

sketchybar --set "$NAME" label="$label" label.color="$label_color"
