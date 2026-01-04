# 🍅 Pomodoro Timer

A minimalist Pomodoro timer app for macOS built with SwiftUI.

## Features

- ⏱️ **Timer**: 25-minute focus sessions with short (5 min) and long (15 min) breaks
- 🔄 **Auto-cycling**: Automatically switches between work and break phases
- 🎯 **Session Tracking**: Long break after every 4 completed sessions
- 🔔 **Notifications**: macOS notifications when sessions complete
- 🔊 **Sound**: Audio alert when timer finishes
- 📊 **Statistics**: Track daily and total focus time with weekly chart
- ⚙️ **Customizable**: Adjust all durations in Settings (⌘,)

## Requirements

- macOS 14.0+
- Xcode 15+

## Building

```bash
# Build the app
swift build

# Run the app
swift run PomodoroApp
```

Or open in Xcode:
```bash
open -a Xcode .
```

## Usage

1. Click **Play** to start a focus session
2. Timer counts down from 25:00
3. When complete, take a **short break** (5 min)
4. After 4 focus sessions, enjoy a **long break** (15 min)
5. View your **statistics** by clicking the chart icon
6. Customize durations in **Settings** (⌘,)

## Project Structure

```
Sources/PomodoroApp/
├── PomodoroApp.swift      # App entry point
├── ContentView.swift      # Main window
├── Models/
│   ├── TimerState.swift   # Enums & settings
│   └── Statistics.swift   # Stats tracking
├── ViewModels/
│   └── PomodoroViewModel.swift
├── Views/
│   ├── TimerView.swift
│   ├── ControlsView.swift
│   ├── SessionIndicator.swift
│   ├── SettingsView.swift
│   └── StatsView.swift
└── Services/
    ├── NotificationService.swift
    ├── SoundService.swift
    └── StorageService.swift
```

## License

MIT
# siwftmodoro
