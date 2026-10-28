import SwiftUI

// MARK: - Task Row View
struct TaskRowView: View {
    let todo: TodoItem
    let theme: AppTheme
    let accentColor: Color
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    @State private var isHovered: Bool = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        HStack(spacing: 9) {
            // Custom Clean Checkbox
            Button(action: onToggle) {
                ZStack {
                    RoundedRectangle(cornerRadius: 3.5)
                        .strokeBorder(todo.isCompleted ? accentColor : theme.checkboxBorder, lineWidth: 1.2)
                        .background(
                            RoundedRectangle(cornerRadius: 3.5)
                                .fill(todo.isCompleted ? accentColor : Color.white.opacity(0.001))
                        )
                        .frame(width: 15, height: 15)
                    
                    if todo.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 7.5, weight: .bold))
                            .foregroundColor(.white)
                            .transition(reduceMotion ? .opacity : .scale.combined(with: .opacity))
                    }
                }
                .frame(width: 22, height: 22)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .contentShape(Rectangle())
            .accessibilityLabel(todo.isCompleted ? "Mark incomplete" : "Mark complete")
            
            // Task Text (Clean Sans-Serif with smooth strikethrough transition)
            Text(todo.text)
                .font(.system(size: 12.5, weight: .regular))
                .foregroundColor(todo.isCompleted ? theme.textSecondary : theme.textPrimary)
                .strikethrough(todo.isCompleted, color: theme.textSecondary.opacity(0.6))
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    onToggle()
                }
            
            // Delete button (reveals on hover, accessible always)
            Button(action: onDelete) {
                Image(systemName: "xmark")
                    .font(.system(size: 8.5, weight: .medium))
                    .foregroundColor(isHovered ? theme.textPrimary : theme.textSecondary.opacity(0.4))
                    .padding(4)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .opacity(isHovered ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 0.15), value: isHovered)
            .accessibilityLabel("Delete task")
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 4)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(isHovered ? theme.rowHover : Color.clear)
        )
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
