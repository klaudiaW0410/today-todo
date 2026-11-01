# Today

A small, quiet menu bar to-do list for macOS.

I built this because I wanted a simple place to keep track of a few daily tasks without having another heavy app open in the Dock. It lives in your status bar, opens with a single click, and stays out of the way when you are focusing on work.

---

## Features

- **Menu bar native**: Runs quietly in the status bar without cluttering your Dock.
- **Three visual themes**:
  - **White**: Clean, bright, and minimal.
  - **Cozy**: Warm ivory paper tone with soft text.
  - **Glassy**: Translucent frosted glass that blends into your desktop wallpaper.
- **Curated accent colors**: Black, Mocha, Caramel, Sage Green, Powder Pink, Olive, Burgundy, and Cool Gray.
- **Appearance screen**: Dedicated customization panel to switch themes and accents easily.
- **Day and year context**: Displays the current date, week number, and remaining days in the year.
- **Progress tracking**: See your completion percentage as you check off items.
- **Saved automatically**: Tasks, selected theme, and chosen colors persist across reboots.
- **Lightweight**: Built purely with native SwiftUI and AppKit (<15 MB RAM, 0% CPU idle).

---

## Installation

### Download pre-built app
1. Download `Today.zip` from this repository or the Releases section.
2. Unzip and drag `Today.app` into your `/Applications` folder.
3. Launch `Today.app`.

> **Note for first launch:**  
> Since this app is distributed as an open-source build without a paid Apple Developer certificate, macOS Gatekeeper may show a warning. To open it:
> - Right-click `Today.app` in Finder and select **Open**, or
> - Run this command in Terminal:
>   ```bash
>   xattr -cr /Applications/Today.app
>   ```

---

## Building from source

Requirements:
- macOS 13.0 (Ventura) or later
- Swift 5.9+ / Xcode command-line tools

Clone the repository and run directly:
```bash
swift run
```

Run unit tests:
```bash
swift test
```

Build a production release binary:
```bash
swift build -c release
cp .build/out/Products/Release/TodayWidget Today.app/Contents/MacOS/Today
codesign --force --deep -s - Today.app
```

---

## License

MIT License. See [LICENSE](LICENSE) for details.
