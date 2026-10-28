import SwiftUI
import AppKit

// MARK: - Application Delegate & Entry Point
@main
class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    private static var appDelegateInstance: AppDelegate?
    
    static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        appDelegateInstance = delegate
        app.delegate = delegate
        app.run()
    }
    
    var menuBarPopover: NSPopover!
    var statusItem: NSStatusItem!
    
    @Published var accentColor: AccentColorChoice = .black
    let todoStore = TodoStore()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        // Load persisted accent color
        if let savedColor = UserDefaults.standard.string(forKey: "widget_accent_color"),
           let parsedColor = AccentColorChoice(rawValue: savedColor) {
            self.accentColor = parsedColor
        }
        
        setupMenuBar()
        
        // Present popover on launch
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showPopover()
        }
    }
    
    func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "checklist", accessibilityDescription: "Today Widget")
            button.action = #selector(statusItemClicked(_:))
            button.target = self
        }
        
        menuBarPopover = NSPopover()
        menuBarPopover.contentSize = NSSize(width: 292, height: 480)
        menuBarPopover.behavior = .transient
        menuBarPopover.animates = true
        menuBarPopover.contentViewController = NSHostingController(
            rootView: MainCardView()
                .environmentObject(todoStore)
                .environmentObject(self)
        )
    }
    
    @objc func statusItemClicked(_ sender: Any?) {
        togglePopover()
    }
    
    func togglePopover() {
        guard statusItem.button != nil else { return }
        if menuBarPopover.isShown {
            menuBarPopover.performClose(nil)
        } else {
            showPopover()
        }
    }
    
    func showPopover() {
        guard let button = statusItem.button else { return }
        NSApp.activate(ignoringOtherApps: true)
        menuBarPopover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
    }
    
    func setAccentColor(_ newColor: AccentColorChoice) {
        self.accentColor = newColor
        UserDefaults.standard.set(newColor.rawValue, forKey: "widget_accent_color")
    }
}
