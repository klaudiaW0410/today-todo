import Foundation

// MARK: - Task Store (Persistence & State)
class TodoStore: ObservableObject {
    @Published var todos: [TodoItem] = [] {
        didSet {
            save()
        }
    }
    
    private let key = "today_stationery_todos_v1"
    
    init() {
        load()
    }
    
    func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([TodoItem].self, from: data) {
            self.todos = decoded
        } else {
            self.todos = [
                TodoItem(text: "Welcome to Today! 👋", isCompleted: false),
                TodoItem(text: "Click the checkbox to complete a task", isCompleted: true),
                TodoItem(text: "Press Return to add your own tasks", isCompleted: false)
            ]
        }
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    func toggle(id: UUID) {
        if let index = todos.firstIndex(where: { $0.id == id }) {
            todos[index].isCompleted.toggle()
        }
    }
    
    func delete(id: UUID) {
        todos.removeAll { $0.id == id }
    }
    
    func add(text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        todos.append(TodoItem(text: trimmed, isCompleted: false))
    }
}
