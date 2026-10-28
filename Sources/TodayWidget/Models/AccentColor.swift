import SwiftUI

// MARK: - Accent Color Palette
enum AccentColorChoice: String, CaseIterable, Identifiable, Codable {
    case black = "Black"
    case coolGray = "Cool Gray"
    case powderPink = "Powder Pink"
    case sageGreen = "Sage Green"
    case oliveGreen = "Olive Green"
    case burgundy = "Burgundy"
    
    var id: String { self.rawValue }
    
    var color: Color {
        switch self {
        case .black:
            return Color(red: 23/255, green: 23/255, blue: 23/255)       // #171717
        case .coolGray:
            return Color(red: 146/255, green: 146/255, blue: 146/255)   // #929292
        case .powderPink:
            return Color(red: 233/255, green: 183/255, blue: 183/255)   // #E9B7B7
        case .sageGreen:
            return Color(red: 145/255, green: 166/255, blue: 154/255)   // #91A69A
        case .oliveGreen:
            return Color(red: 128/255, green: 132/255, blue: 91/255)    // #80845B
        case .burgundy:
            return Color(red: 112/255, green: 43/255, blue: 61/255)     // #702B3D
        }
    }
}
