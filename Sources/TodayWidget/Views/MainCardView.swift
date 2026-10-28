import SwiftUI
import AppKit

// MARK: - Main Menu Bar Card View
struct MainCardView: View {
    @EnvironmentObject var todoStore: TodoStore
    @EnvironmentObject var appDelegate: AppDelegate
    
    @State private var newTodoText: String = ""
    @State private var isThemePickerOpen: Bool = false
    @FocusState private var isInputFocused: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    private var theme: AppTheme {
        appDelegate.theme
    }
    
    private var progressPercent: Int {
        guard !todoStore.todos.isEmpty else { return 0 }
        let completed = todoStore.todos.filter { $0.isCompleted }.count
        return Int((Double(completed) / Double(todoStore.todos.count)) * 100)
    }
    
    private var completedCount: Int {
        todoStore.todos.filter { $0.isCompleted }.count
    }
    
    private var totalCount: Int {
        todoStore.todos.count
    }
    
    private var daysLeftInYear: Int {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        if let endOfYear = calendar.date(from: DateComponents(year: year, month: 12, day: 31, hour: 23, minute: 59)) {
            let diff = calendar.dateComponents([.day], from: Date(), to: endOfYear)
            return max(0, diff.day ?? 0)
        }
        return 0
    }
    
    private var weekNumber: Int {
        Calendar.current.component(.weekOfYear, from: Date())
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            topBarSection
            
            // Expandable In-Card Theme Selector
            if isThemePickerOpen {
                ThemePickerView(
                    currentTheme: theme,
                    accentColor: appDelegate.accentColor.color,
                    onSelectTheme: { selectedTheme in
                        appDelegate.setTheme(selectedTheme)
                        withAnimation(reduceMotion ? .none : .spring(response: 0.25, dampingFraction: 0.8)) {
                            isThemePickerOpen = false
                        }
                    },
                    onClose: {
                        withAnimation(reduceMotion ? .none : .spring(response: 0.25, dampingFraction: 0.8)) {
                            isThemePickerOpen = false
                        }
                    }
                )
                .transition(
                    reduceMotion
                        ? .opacity
                        : .asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .top)),
                            removal: .opacity.combined(with: .move(edge: .top))
                        )
                )
                .padding(.bottom, 12)
            }
            
            headerSection
            progressSection
            
            Divider()
                .background(theme.borderSubtle)
                .padding(.bottom, 8)
            
            taskListSection
            addTaskSection
            
            Spacer(minLength: 4)
            
            footerSection
        }
        .padding(16)
        .frame(width: 292, height: 490)
        .background(cardBackgroundView)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(theme.cardBorder, lineWidth: 1)
        )
        .shadow(color: theme.shadowColor, radius: 12, x: 0, y: 4)
        .animation(.easeInOut(duration: 0.2), value: appDelegate.theme)
        .animation(.easeInOut(duration: 0.15), value: appDelegate.accentColor)
    }
    
    // MARK: - Dynamic Card Background
    @ViewBuilder
    private var cardBackgroundView: some View {
        switch theme {
        case .white:
            Color.white
        case .cozy:
            LinearGradient(
                colors: [
                    Color(red: 247/255, green: 242/255, blue: 232/255),
                    Color(red: 244/255, green: 238/255, blue: 227/255)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .glassy:
            ZStack {
                VisualEffectView(material: .popover, blendingMode: .behindWindow, state: .active)
                LinearGradient(
                    colors: [Color.white.opacity(0.15), Color.white.opacity(0.03)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }
    
    // MARK: - 1. Top Bar Section
    private var topBarSection: some View {
        HStack(alignment: .center, spacing: 6) {
            // Date / Time Pill
            HStack(spacing: 5) {
                Text(Date().formatted(.dateTime.month(.abbreviated)).uppercased())
                    .font(.system(size: 9.5, weight: .bold))
                    .foregroundColor(appDelegate.accentColor.color)
                
                Text("•")
                    .font(.system(size: 8))
                    .foregroundColor(theme.borderSubtle)
                
                Text("\(Date().formatted(.dateTime.hour().minute()))")
                    .font(.system(size: 9.5, weight: .medium, design: .monospaced))
                    .foregroundColor(theme.textSecondary)
            }
            .padding(.horizontal, 7)
            .padding(.vertical, 3.5)
            .background(theme.surfaceMuted)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(theme.borderSubtle.opacity(0.5), lineWidth: 0.5)
            )
            
            Spacer()
            
            // Theme Selector Toggle Button
            Button(action: {
                withAnimation(reduceMotion ? .none : .spring(response: 0.28, dampingFraction: 0.8)) {
                    isThemePickerOpen.toggle()
                }
            }) {
                HStack(spacing: 3) {
                    Image(systemName: isThemePickerOpen ? "paintpalette.fill" : "paintpalette")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(isThemePickerOpen ? appDelegate.accentColor.color : theme.textSecondary)
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 3.5)
                .background(isThemePickerOpen ? appDelegate.accentColor.color.opacity(0.12) : theme.surfaceMuted)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(isThemePickerOpen ? appDelegate.accentColor.color.opacity(0.4) : theme.borderSubtle.opacity(0.4), lineWidth: 0.5)
                )
            }
            .buttonStyle(.plain)
            .help("Theme: \(theme.displayName)")
            
            // Accent Color Swatches (Refined compact footprint)
            HStack(spacing: 4) {
                ForEach(AccentColorChoice.allCases) { choice in
                    let isSelected = (appDelegate.accentColor == choice)
                    
                    Button(action: {
                        appDelegate.setAccentColor(choice)
                    }) {
                        ZStack {
                            Circle()
                                .fill(choice.color)
                                .frame(width: 9.5, height: 9.5)
                            
                            if isSelected {
                                Circle()
                                    .strokeBorder(theme.textPrimary, lineWidth: 1.1)
                                    .frame(width: 14.5, height: 14.5)
                            }
                        }
                        .frame(width: 15, height: 15)
                        .contentShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .help("Accent: \(choice.rawValue)")
                }
            }
            
            // Quit Button
            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                Image(systemName: "power")
                    .font(.system(size: 9.5, weight: .medium))
                    .foregroundColor(theme.textSecondary.opacity(0.8))
                    .padding(4)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .help("Quit Today")
        }
        .padding(.bottom, 12)
    }
    
    // MARK: - 2. Header Section
    private var headerSection: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 1.5) {
                Text("Today")
                    .font(.system(size: 23, weight: .bold, design: .default))
                    .foregroundColor(theme.textPrimary)
                    .tracking(-0.35)
                
                Text("\(Date().formatted(.dateTime.weekday(.wide))) • Week \(weekNumber)")
                    .font(.system(size: 10.5, weight: .regular))
                    .foregroundColor(theme.textSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 1.5) {
                Text("\(daysLeftInYear) days left")
                    .font(.system(size: 10.5, weight: .medium))
                    .foregroundColor(theme.textPrimary)
                
                Text(String(Calendar.current.component(.year, from: Date())))
                    .font(.system(size: 9.5, weight: .regular, design: .monospaced))
                    .foregroundColor(theme.textSecondary)
            }
        }
        .padding(.bottom, 12)
    }
    
    // MARK: - 3. Progress Section
    private var progressSection: some View {
        VStack(spacing: 6) {
            HStack {
                Text("\(completedCount) of \(totalCount) completed")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(theme.textSecondary)
                
                Spacer()
                
                Text("\(progressPercent)%")
                    .font(.system(size: 10.5, weight: .semibold, design: .monospaced))
                    .foregroundColor(theme.textPrimary)
            }
            
            // Thin progress track with spring fill
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(theme.surfaceMuted)
                        .frame(height: 3.5)
                    
                    Capsule()
                        .fill(appDelegate.accentColor.color)
                        .frame(
                            width: max(0, min(geo.size.width * CGFloat(progressPercent) / 100.0, geo.size.width)),
                            height: 3.5
                        )
                        .animation(reduceMotion ? .none : .spring(response: 0.3, dampingFraction: 0.8), value: progressPercent)
                }
            }
            .frame(height: 3.5)
        }
        .padding(.bottom, 11)
    }
    
    // MARK: - 4. Task List Section
    private var taskListSection: some View {
        ScrollView(showsIndicators: false) {
            if todoStore.todos.isEmpty {
                VStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 15))
                        .foregroundColor(appDelegate.accentColor.color.opacity(0.85))
                        .padding(.top, 36)
                    
                    Text("All clear for today")
                        .font(.system(size: 12.5, weight: .medium))
                        .foregroundColor(theme.textPrimary)
                    
                    Text("Add a task below to get started")
                        .font(.system(size: 10))
                        .foregroundColor(theme.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 180)
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(todoStore.todos) { todo in
                        TaskRowView(
                            todo: todo,
                            theme: theme,
                            accentColor: appDelegate.accentColor.color,
                            onToggle: {
                                withAnimation(reduceMotion ? .none : .spring(response: 0.22, dampingFraction: 0.75)) {
                                    todoStore.toggle(id: todo.id)
                                }
                            },
                            onDelete: {
                                withAnimation(reduceMotion ? .none : .easeOut(duration: 0.16)) {
                                    todoStore.delete(id: todo.id)
                                }
                            }
                        )
                    }
                }
            }
        }
        .frame(maxHeight: isThemePickerOpen ? 120 : 210)
        .animation(.spring(response: 0.28, dampingFraction: 0.8), value: isThemePickerOpen)
    }
    
    // MARK: - 5. Add Task Input Section
    private var addTaskSection: some View {
        HStack(spacing: 8) {
            Image(systemName: "plus")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(appDelegate.accentColor.color)
            
            TextField("Add task...", text: $newTodoText)
                .textFieldStyle(.plain)
                .font(.system(size: 12.5, weight: .regular))
                .foregroundColor(theme.textPrimary)
                .focused($isInputFocused)
                .onSubmit {
                    submitNewTask()
                }
        }
        .padding(.vertical, 7)
        .padding(.horizontal, 6)
        .background(isInputFocused ? theme.surfaceMuted : Color.clear)
        .cornerRadius(6)
        .overlay(
            Rectangle()
                .frame(height: 0.8)
                .foregroundColor(isInputFocused ? appDelegate.accentColor.color.opacity(0.7) : theme.borderSubtle),
            alignment: .top
        )
        .animation(.easeInOut(duration: 0.14), value: isInputFocused)
        .padding(.top, 4)
    }
    
    // MARK: - 6. Footer Section
    private var footerSection: some View {
        HStack {
            Text("Press Return to add • Click to complete")
                .font(.system(size: 9, weight: .regular))
                .foregroundColor(theme.textMuted)
            
            Spacer()
            
            Text("\(theme.displayName) • \(appDelegate.accentColor.rawValue)")
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(theme.textSecondary)
        }
        .padding(.top, 6)
    }
    
    // MARK: - Actions
    private func submitNewTask() {
        let trimmed = newTodoText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        withAnimation(reduceMotion ? .none : .spring(response: 0.24, dampingFraction: 0.8)) {
            todoStore.add(text: trimmed)
        }
        newTodoText = ""
        isInputFocused = true
    }
}
