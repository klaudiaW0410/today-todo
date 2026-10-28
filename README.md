# Today. — Minimalist Menu Bar To-Do Widget for macOS ✉️

A native, lightweight macOS menu bar companion built with **SwiftUI** & **AppKit**, designed as an aesthetic, stationery-inspired to-do list right in your status bar.

---

## ✨ Features
- 📋 **Menu Bar Native**: Unobtrusive icon in the macOS menu bar — click anytime to view or toggle your checklist.
- 🎭 **3 Selectable Themes**: Switch effortlessly between:
  - **White**: Clean, crisp, bright minimal Apple aesthetic.
  - **Cozy**: Warm ivory stationery paper tone with calming charcoal typography.
  - **Glassy**: Genuine translucent frosted-glass material with wallpaper blur and depth.
- 🎨 **Independent Accent Colors**: 6 curated stationery colors (*Black*, *Cool Gray*, *Powder Pink*, *Sage Green*, *Olive Green*, *Burgundy*).
- 🗓️ **Calendar & Year Stats**: Displays current month, time, ISO week number, and live countdown of remaining days in the year.
- ✍️ **Cozy Checklist**: Spring animations, progress bar with completion percentage, and intuitive task management.
- 💾 **Automatic Persistence**: Tasks, selected theme, and accent color are saved automatically to `UserDefaults`.
- ⚡ **Ultra Lightweight**: Pure native Swift app (<15 MB RAM, 0% CPU idle).
- ⏻ **One-Click Quit**: Convenient power button in the widget header to exit whenever needed.

---

## 💻 Requirements
- **macOS 13.0 (Ventura)** or later
- Apple Silicon (M1/M2/M3/M4) or Intel Mac

---

## 🚀 How to Run & Install

### Option 1: Run Pre-Packaged App
1. Download or clone this repository.
2. Launch the app directly:
   ```bash
   open Today.app
   ```

> [!NOTE]
> **First-time launch on macOS (Gatekeeper)**:
> Since this open-source app is not notarized with an Apple Developer ID certificate, macOS might show a warning. To allow it, run:
> ```bash
> xattr -cr Today.app
> ```
> Or **Right-click** on `Today.app` in Finder and select **Open**.

---

### Option 2: Build & Develop from Source

**Open in Xcode:**
```bash
xed .
```

**Run from Terminal:**
```bash
swift run
```

**Run Unit Tests:**
```bash
swift test
```

**Rebuild `Today.app` for Production:**
```bash
swift build -c release
cp .build/release/TodayWidget Today.app/Contents/MacOS/Today
```

---

## 🧪 Testing

The project includes unit test coverage for store actions, task model persistence, validation, and accent choices. Run tests with:
```bash
swift test
```

---

## 📄 License
This project is licensed under the [MIT License](LICENSE).
