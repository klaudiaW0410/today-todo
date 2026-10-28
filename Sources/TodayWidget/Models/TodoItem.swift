import Foundation

// MARK: - Task Item Model
struct TodoItem: Identifiable, Codable {
    var id = UUID()
    var text: String
    var isCompleted: Bool = false
}
