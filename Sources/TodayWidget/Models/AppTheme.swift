import SwiftUI

// MARK: - Application Theme Model
enum AppTheme: String, CaseIterable, Identifiable, Codable {
    case white = "White"
    case cozy = "Cozy"
    case glassy = "Glassy"
    
    var id: String { rawValue }
    
    var displayName: String { rawValue }
    
    var iconName: String {
        switch self {
        case .white: return "sun.max"
        case .cozy: return "book.closed"
        case .glassy: return "sparkles"
        }
    }
    
    var subtitle: String {
        switch self {
        case .white: return "Clean, bright & minimal"
        case .cozy: return "Warm ivory & calm paper"
        case .glassy: return "Translucent frosted glass"
        }
    }
    
    // MARK: - Color & Material Tokens
    
    var isGlassy: Bool {
        self == .glassy
    }
    
    var textPrimary: Color {
        switch self {
        case .white:
            return Color(red: 24/255, green: 24/255, blue: 27/255)       // #18181B Crisp Charcoal
        case .cozy:
            return Color(red: 45/255, green: 41/255, blue: 38/255)       // #2D2926 Warm Charcoal
        case .glassy:
            return Color.primary                                          // Adaptive system primary
        }
    }
    
    var textSecondary: Color {
        switch self {
        case .white:
            return Color(red: 113/255, green: 113/255, blue: 122/255)   // #71717A Neutral
        case .cozy:
            return Color(red: 140/255, green: 130/255, blue: 122/255)   // #8C827A Warm Muted
        case .glassy:
            return Color.secondary                                        // Adaptive system secondary
        }
    }
    
    var textMuted: Color {
        switch self {
        case .white:
            return Color(red: 161/255, green: 161/255, blue: 170/255)   // #A1A1AA
        case .cozy:
            return Color(red: 168/255, green: 158/255, blue: 150/255)   // #A89E96
        case .glassy:
            return Color.secondary.opacity(0.7)
        }
    }
    
    var surfaceMuted: Color {
        switch self {
        case .white:
            return Color(red: 244/255, green: 244/255, blue: 245/255)   // #F4F4F5
        case .cozy:
            return Color(red: 239/255, green: 233/255, blue: 220/255)   // #EFE9DC Warm pill
        case .glassy:
            return Color.primary.opacity(0.07)                            // Adaptive tint
        }
    }
    
    var borderSubtle: Color {
        switch self {
        case .white:
            return Color(red: 228/255, green: 228/255, blue: 231/255)   // #E4E4E7
        case .cozy:
            return Color(red: 228/255, green: 221/255, blue: 208/255)   // #E4DDD0 Warm separator
        case .glassy:
            return Color.white.opacity(0.18)                              // Translucent rim
        }
    }
    
    var cardBorder: Color {
        switch self {
        case .white:
            return Color(red: 228/255, green: 228/255, blue: 231/255)
        case .cozy:
            return Color(red: 220/255, green: 212/255, blue: 198/255)
        case .glassy:
            return Color.white.opacity(0.25)
        }
    }
    
    var cardBackground: Color {
        switch self {
        case .white:
            return Color(red: 255/255, green: 255/255, blue: 255/255)
        case .cozy:
            return Color(red: 247/255, green: 242/255, blue: 232/255)   // #F7F2E8 Ivory
        case .glassy:
            return Color.clear                                            // Material shows through
        }
    }
    
    var rowHover: Color {
        switch self {
        case .white:
            return Color(red: 244/255, green: 244/255, blue: 245/255).opacity(0.7)
        case .cozy:
            return Color(red: 235/255, green: 228/255, blue: 216/255).opacity(0.6)
        case .glassy:
            return Color.primary.opacity(0.06)
        }
    }
    
    var checkboxBorder: Color {
        switch self {
        case .white:
            return Color(red: 212/255, green: 212/255, blue: 216/255)
        case .cozy:
            return Color(red: 210/255, green: 200/255, blue: 186/255)
        case .glassy:
            return Color.primary.opacity(0.28)
        }
    }
    
    var shadowColor: Color {
        switch self {
        case .white:
            return Color.black.opacity(0.04)
        case .cozy:
            return Color(red: 60/255, green: 40/255, blue: 20/255).opacity(0.05)
        case .glassy:
            return Color.black.opacity(0.12)
        }
    }
}
