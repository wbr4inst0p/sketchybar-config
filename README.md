# SketchyBar config

Personal [SketchyBar](https://github.com/FelixKratz/SketchyBar) setup for macOS: a minimal top bar with a frosted pill style and a few productivity widgets.

## Prerequisites

- [SketchyBar](https://github.com/FelixKratz/SketchyBar) installed and running
- [Hack Nerd Font](https://www.nerdfonts.com/font-downloads) (used for icons and labels in `sketchybarrc`)

## Install

Clone or copy this repo to SketchyBar’s config directory:

```bash
git clone git@github.com:wbr4inst0p/sketchybar-config.git ~/.config/sketchybar
```

If you already have a config there, back it up first, then replace or merge as you prefer.

Reload after changes:

```bash
sketchybar --reload
```

## Bar layout

| Position | Item      | Description                          |
|----------|-----------|--------------------------------------|
| Center   | **clock** | Date and time (`DD/MM HH:MM`)        |
| Right    | **pomodoro** | 25 / 5 / 15 minute Pomodoro timer |
| Right    | **water** | Hydration reminder countdown         |

The bar is top-aligned, 25px tall, with a fully transparent background. Active items use a semi-transparent dark pill (`background.color=0x40000000`, corner radius 8, light blur).

## Widget controls

### Pomodoro (`plugins/pomodoro.sh`)

- **Left click** — start / pause
- **Right click** — reset (fresh work session, counter cleared)
- **Shift + left click** — skip to the next phase (work → short break → work, long break every 4 completed work sessions)

Timer state is stored in `~/.cache/sketchybar/pomodoro.state` so it survives bar reloads. macOS notifications fire when phases change.

Label colors: red (work), green (short break), cyan (long break); paused state is gray with a pause prefix.

### Water (`plugins/water.sh`)

- Counts down from **60 minutes** (configurable via `INTERVAL_MIN` in the script)
- When time is up, the label shows **Drink water!** in red
- **Click** (any button) to acknowledge and restart the countdown

State file: `~/.cache/sketchybar/water.state`

## Project structure

```
sketchybarrc          # Main bar definition
plugins/
  clock.sh            # Date/time label
  pomodoro.sh         # Pomodoro timer
  water.sh            # Water reminder
  battery.sh          # Example: battery icon + % (not wired in sketchybarrc)
  volume.sh           # Example: volume on volume_change event
  front_app.sh        # Example: focused app name
  space.sh            # Example: Mission Control space highlight
```

The `battery`, `volume`, `front_app`, and `space` scripts are useful starting points from the upstream SketchyBar demo; add them in `sketchybarrc` if you want those items on the bar.

## Customization

- **Fonts and default item style** — `default=(...)` block at the top of `sketchybarrc`
- **Pomodoro durations** — `WORK_SEC`, `SHORT_BREAK_SEC`, `LONG_BREAK_SEC`, and `CYCLES_BEFORE_LONG_BREAK` in `plugins/pomodoro.sh`
- **Water interval** — `INTERVAL_MIN` in `plugins/water.sh`

SketchyBar docs: [configuration reference](https://felixkratz.github.io/SketchyBar/config/bar)

## License

Use and adapt freely for your own setup.
