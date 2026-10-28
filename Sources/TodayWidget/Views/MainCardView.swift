import SwiftUI
import AppKit

// MARK: - Main Menu Bar Card View
struct MainCardView: View {
    @EnvironmentObject var todoStore: TodoStore
    @EnvironmentObject var appDelegate: AppDelegate
    @State private var newTodoText: String = ""
    
    // Base Color Tokens
    private let bgWhite = Color.white
    private let textPrimary = Color(red: 23/255, green: 23/255, blue: 23/255)        // #171717
    private let textSecondary = Color(red: 133/255, green: 133/255, blue: 133/255)  // #858585
    private let borderSubtle = Color(red: 229/255, green: 229/255, blue: 229/255)   // #E5E5E5
    private let surfaceMuted = Color(red: 248/255, green: 248/255, blue: 248/255)   // #F8F8F8
    
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            topBarSection
            headerSection
            progressSection
            
            Divider()
                .background(borderSubtle)
                .padding(.bottom, 8)
            
            taskListSection
            addTaskSection
            
            Spacer()
            
            footerSection
        }
        .padding(18)
        .frame(width: 292, height: 480)
        .background(bgWhite)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderSubtle, lineWidth: 1)
        )
    }
    
    // MARK: - Subviews
    
    private var topBarSection: some View {
        HStack(alignment: .center) {
            // Minimal date pill
            HStack(spacing: 5) {
                Text(Date().formatted(.dateTime.month(.abbreviated)).uppercased())
                    .font(.system(size: 9.5, weight: .bold))
                    .foregroundColor(appDelegate.accentColor.color)
                
                Text("•")
                    .font(.system(size: 8))
                    .foregroundColor(borderSubtle)
                
                Text("\(Date().formatted(.dateTime.hour().minute()))")
                    .font(.system(size: 9.5, weight: .medium, design: .monospaced))
                    .foregroundColor(textSecondary)
            }
            .padding(.horizontal, 7)
            .padding(.vertical, 3.5)
            .background(surfaceMuted)
            .cornerRadius(5)
            
            Spacer()
            
            // Accent Color Selector (Functional 6 Swatches)
            HStack(spacing: 5) {
                ForEach(AccentColorChoice.allCases) { choice in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            appDelegate.setAccentColor(choice)
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(choice.color)
                                .frame(width: 11, height: 11)
                            
                            if appDelegate.accentColor == choice {
                                Circle()
                                    .strokeBorder(textPrimary, lineWidth: 1.2)
                                    .frame(width: 16, height: 16)
                            }
                        }
                        .frame(width: 16, height: 16)
                    }
                    .buttonStyle(.plain)
                    .help(choice.rawValue)
                }
            }
            
            // Power / Quit Button
            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                Image(systemName: "power")
                    .font(.system(size: 9.5, weight: .medium))
                    .foregroundColor(textSecondary.opacity(0.7))
                    .padding(4)
            }
            .buttonStyle(.plain)
            .help("Quit Today")
        }
        .padding(.bottom, 14)
    }
    
    private var headerSection: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 1) {
                Text("Today")
                    .font(.system(size: 22, weight: .semibold, design: .default))
                    .foregroundColor(textPrimary)
                    .tracking(-0.3)
                
                Text("\(Date().formatted(.dateTime.weekday(.wide))) • Week \(Calendar.current.component(.weekOfYear, from: Date()))")
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(textSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 1) {
                Text("\(daysLeftInYear) days left")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(textPrimary)
                
                Text(String(Calendar.current.component(.year, from: Date())))
                    .font(.system(size: 9.5, weight: .regular))
                    .foregroundColor(textSecondary)
            }
        }
        .padding(.bottom, 14)
    }
    
    private var progressSection: some View {
        VStack(spacing: 6) {
            HStack {
                Text("\(completedCount) of \(totalCount) completed")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(textSecondary)
                
                Spacer()
                
                Text("\(progressPercent)%")
                    .font(.system(size: 10.5, weight: .semibold, design: .monospaced))
                    .foregroundColor(textPrimary)
            }
            
            // Thin progress track
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(surfaceMuted)
                        .frame(height: 3.5)
                    
                    Capsule()
                        .fill(appDelegate.accentColor.color)
                        .frame(width: max(0, min(geo.size.width * CGFloat(progressPercent) / 100.0, geo.size.width)), height: 3.5)
                        .animation(.easeOut(duration: 0.25), value: progressPercent)
                }
            }
            .frame(height: 3.5)
        }
        .padding(.bottom, 12)
    }
    
    private var taskListSection: some View {
        ScrollView(showsIndicators: false) {
            if todoStore.todos.isEmpty {
                VStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 15))
                        .foregroundColor(appDelegate.accentColor.color.opacity(0.8))
                        .padding(.top, 40)
                    Text("All clear for today")
                        .font(.system(size: 12.5, weight: .medium))
                        .foregroundColor(textSecondary)
                    Text("Add a task below to get started")
                        .font(.system(size: 10))
                        .foregroundColor(textSecondary.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 180)
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(todoStore.todos) { todo in
                        TaskRowView(
                            todo: todo,
                            accentColor: appDelegate.accentColor.color,
                            onToggle: {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    todoStore.toggle(id: todo.id)
                                }
                            },
                            onDelete: {
                                withAnimation(.easeOut(duration: 0.15)) {
                                    todoStore.delete(id: todo.id)
                                }
                            }
                        )
                    }
                }
            }
        }
        .frame(maxHeight: 220)
    }
    
    private var addTaskSection: some View {
        HStack(spacing: 8) {
            Image(systemName: "plus")
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(appDelegate.accentColor.color)
            
            TextField("Add task...", text: $newTodoText)
                .textFieldStyle(.plain)
                .font(.system(size: 12.5, weight: .regular))
                .foregroundColor(textPrimary)
                .onSubmit {
                    todoStore.add(text: newTodoText)
                    newTodoText = ""
                }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .background(Color.clear)
        .overlay(
            Rectangle()
                .frame(height: 0.8)
                .foregroundColor(borderSubtle),
            alignment: .top
        )
        .padding(.top, 4)
    }
    
    private var footerSection: some View {
        HStack {
            Text("Press Return to add • Click to complete")
                .font(.system(size: 9, weight: .regular))
                .foregroundColor(textSecondary)
            
            Spacer()
            
            Text(appDelegate.accentColor.rawValue)
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(textSecondary)
        }
        .padding(.top, 8)
    }
}
