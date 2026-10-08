#!/usr/bin/env bash

# Water reminder widget for SketchyBar
#
# Counts down from INTERVAL_MIN. When it hits zero, the label turns red
# and shows "Drink water!". Click the widget (any button) once you've had
# some water to acknowledge the alert and restart the countdown.

STATE_DIR="$HOME/.cache/sketchybar"
STATE_FILE="$STATE_DIR/water.state"
mkdir -p "$STATE_DIR"

INTERVAL_MIN=60
INTERVAL_SEC=$((INTERVAL_MIN * 60))

# remaining=<seconds until next reminder> alert=0/1
if [ ! -f "$STATE_FILE" ]; then
  echo "remaining=$INTERVAL_SEC alert=0" > "$STATE_FILE"
fi
# shellcheck disable=SC1090
source "$STATE_FILE"

save_state() {
  echo "remaining=$remaining alert=$alert" > "$STATE_FILE"
}

if [ -n "$BUTTON" ]; then
  # Any click acknowledges the reminder ("I drank water") and restarts the timer.
  remaining=$INTERVAL_SEC
  alert=0
elif [ "$SENDER" = "routine" ]; then
  if [ "$alert" != "1" ]; then
    remaining=$((remaining - 1))
    if [ "$remaining" -le 0 ]; then
      remaining=0
      alert=1
    fi
  fi
fi

save_state

if [ "$alert" = "1" ]; then
  label="Drink water!"
  color=0xffff5555
else
  minutes=$((remaining / 60))
  seconds=$((remaining % 60))
  label=$(printf "%02d:%02d" "$minutes" "$seconds")
  color=0xff61afef
fi

sketchybar --set "$NAME" label="$label" label.color="$color"
