import SwiftUI

// MARK: - Task Row View
struct TaskRowView: View {
    let todo: TodoItem
    let accentColor: Color
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    @State private var isHovered: Bool = false
    
    private let textPrimary = Color(red: 23/255, green: 23/255, blue: 23/255)
    private let textSecondary = Color(red: 133/255, green: 133/255, blue: 133/255)
    private let borderSubtle = Color(red: 229/255, green: 229/255, blue: 229/255)
    
    var body: some View {
        HStack(spacing: 9) {
            // Custom Clean Checkbox
            Button(action: onToggle) {
                ZStack {
                    RoundedRectangle(cornerRadius: 3.5)
                        .strokeBorder(todo.isCompleted ? accentColor : Color(red: 200/255, green: 200/255, blue: 200/255), lineWidth: 1.2)
                        .background(
                            RoundedRectangle(cornerRadius: 3.5)
                                .fill(todo.isCompleted ? accentColor : Color.white.opacity(0.001))
                        )
                        .frame(width: 15, height: 15)
                    
                    if todo.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 7.5, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 22, height: 22)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .contentShape(Rectangle())
            
            // Task Text (Clean Sans-Serif)
            Text(todo.text)
                .font(.system(size: 12.5, weight: .regular))
                .foregroundColor(todo.isCompleted ? textSecondary : textPrimary)
                .strikethrough(todo.isCompleted, color: textSecondary.opacity(0.6))
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    onToggle()
                }
            
            // Delete button (subtle)
            Button(action: onDelete) {
                Image(systemName: "xmark")
                    .font(.system(size: 8.5, weight: .medium))
                    .foregroundColor(isHovered ? textPrimary : textSecondary.opacity(0.4))
                    .padding(3)
            }
            .buttonStyle(.plain)
            .opacity(isHovered ? 1 : 0.3)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 2)
        .background(isHovered ? Color(red: 250/255, green: 250/255, blue: 250/255) : Color.clear)
        .cornerRadius(4)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
