import XCTest
@testable import TodayWidget

final class TodoStoreTests: XCTestCase {
    var store: TodoStore!
    private let testKey = "today_stationery_todos_v1"
    
    override func setUp() {
        super.setUp()
        // Clear test UserDefaults before each test
        UserDefaults.standard.removeObject(forKey: testKey)
        store = TodoStore()
        store.todos = [] // Start with an empty list for predictable testing
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: testKey)
        store = nil
        super.tearDown()
    }
    
    func testAddTask() {
        XCTAssertTrue(store.todos.isEmpty)
        
        store.add(text: "Buy groceries")
        
        XCTAssertEqual(store.todos.count, 1)
        XCTAssertEqual(store.todos.first?.text, "Buy groceries")
        XCTAssertEqual(store.todos.first?.isCompleted, false)
    }
    
    func testAddTaskTrimsWhitespace() {
        store.add(text: "   Clean desk   \n")
        
        XCTAssertEqual(store.todos.count, 1)
        XCTAssertEqual(store.todos.first?.text, "Clean desk")
    }
    
    func testAddEmptyTaskIgnored() {
        store.add(text: "")
        store.add(text: "   ")
        store.add(text: "\n\t")
        
        XCTAssertTrue(store.todos.isEmpty)
    }
    
    func testToggleTask() {
        store.add(text: "Finish homework")
        guard let task = store.todos.first else {
            XCTFail("Task should exist")
            return
        }
        
        XCTAssertFalse(task.isCompleted)
        
        // Toggle to completed
        store.toggle(id: task.id)
        XCTAssertTrue(store.todos.first?.isCompleted ?? false)
        
        // Toggle back to incomplete
        store.toggle(id: task.id)
        XCTAssertFalse(store.todos.first?.isCompleted ?? true)
    }
    
    func testDeleteTask() {
        store.add(text: "Task 1")
        store.add(text: "Task 2")
        XCTAssertEqual(store.todos.count, 2)
        
        let firstTaskId = store.todos[0].id
        store.delete(id: firstTaskId)
        
        XCTAssertEqual(store.todos.count, 1)
        XCTAssertEqual(store.todos.first?.text, "Task 2")
    }
    
    func testPersistenceToUserDefaults() {
        store.add(text: "Persistent Item")
        
        // Create a new store instance to verify it loads saved data
        let newStore = TodoStore()
        XCTAssertEqual(newStore.todos.count, 1)
        XCTAssertEqual(newStore.todos.first?.text, "Persistent Item")
    }
    
    func testAccentColorChoices() {
        for choice in AccentColorChoice.allCases {
            XCTAssertFalse(choice.rawValue.isEmpty)
            XCTAssertEqual(choice.id, choice.rawValue)
            _ = choice.color // Ensure color accessor does not crash
        }
    }
}
