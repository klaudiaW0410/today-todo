import SwiftUI

// MARK: - Dedicated Appearance & Theme View
struct ThemePickerView: View {
    let currentTheme: AppTheme
    let accentColor: Color
    let currentAccentColor: AccentColorChoice
    let onSelectTheme: (AppTheme) -> Void
    let onSelectAccentColor: (AccentColorChoice) -> Void
    let onClose: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 13) {
            // Header
            HStack(alignment: .center) {
                HStack(spacing: 6) {
                    Image(systemName: "paintpalette.fill")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(accentColor)
                    
                    Text("Appearance")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(currentTheme.textPrimary)
                }
                
                Spacer()
                
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(currentTheme.textSecondary.opacity(0.6))
                        .padding(2)
                }
                .buttonStyle(.plain)
                .help("Back to Tasks")
            }
            .padding(.top, 2)
            
            // Section 1: Themes
            VStack(alignment: .leading, spacing: 6) {
                Text("THEME")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(currentTheme.textSecondary.opacity(0.85))
                    .tracking(0.6)
                
                VStack(spacing: 5) {
                    ForEach(AppTheme.allCases) { theme in
                        let isSelected = (theme == currentTheme)
                        
                        Button(action: {
                            onSelectTheme(theme)
                        }) {
                            HStack(spacing: 10) {
                                themePreviewSwatch(for: theme)
                                
                                VStack(alignment: .leading, spacing: 1.5) {
                                    HStack(spacing: 5) {
                                        Text(theme.displayName)
                                            .font(.system(size: 12, weight: isSelected ? .semibold : .medium))
                                            .foregroundColor(currentTheme.textPrimary)
                                        
                                        if isSelected {
                                            Text("Active")
                                                .font(.system(size: 8, weight: .semibold))
                                                .foregroundColor(accentColor)
                                                .padding(.horizontal, 4.5)
                                                .padding(.vertical, 1)
                                                .background(accentColor.opacity(0.14))
                                                .cornerRadius(3)
                                        }
                                    }
                                    
                                    Text(theme.subtitle)
                                        .font(.system(size: 9.5, weight: .regular))
                                        .foregroundColor(currentTheme.textSecondary)
                                }
                                
                                Spacer()
                                
                                ZStack {
                                    Circle()
                                        .strokeBorder(isSelected ? accentColor : currentTheme.borderSubtle, lineWidth: 1.2)
                                        .frame(width: 14, height: 14)
                                    
                                    if isSelected {
                                        Circle()
                                            .fill(accentColor)
                                            .frame(width: 7, height: 7)
                                    }
                                }
                                .frame(width: 16, height: 16)
                            }
                            .padding(.vertical, 7)
                            .padding(.horizontal, 9)
                            .background(
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(isSelected ? currentTheme.surfaceMuted : Color.clear)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 7)
                                    .stroke(isSelected ? accentColor.opacity(0.45) : currentTheme.borderSubtle.opacity(0.4), lineWidth: 0.8)
                            )
                        }
                        .buttonStyle(.plain)
                        .help("Switch to \(theme.displayName)")
                    }
                }
            }
            
            // Section 2: Accent Colors
            VStack(alignment: .leading, spacing: 6) {
                Text("ACCENT COLOR")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(currentTheme.textSecondary.opacity(0.85))
                    .tracking(0.6)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 4), spacing: 6) {
                    ForEach(AccentColorChoice.allCases) { choice in
                        let isSelected = (currentAccentColor == choice)
                        
                        Button(action: {
                            onSelectAccentColor(choice)
                        }) {
                            VStack(spacing: 3) {
                                ZStack {
                                    Circle()
                                        .fill(choice.color)
                                        .frame(width: 16, height: 16)
                                    
                                    if isSelected {
                                        Circle()
                                            .strokeBorder(currentTheme.textPrimary, lineWidth: 1.3)
                                            .frame(width: 22, height: 22)
                                    }
                                }
                                .frame(width: 24, height: 24)
                                
                                Text(choice.rawValue)
                                    .font(.system(size: 8, weight: isSelected ? .semibold : .regular))
                                    .foregroundColor(isSelected ? currentTheme.textPrimary : currentTheme.textSecondary)
                                    .lineLimit(1)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 3)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(isSelected ? currentTheme.surfaceMuted.opacity(0.7) : Color.clear)
                            )
                        }
                        .buttonStyle(.plain)
                        .help("Accent: \(choice.rawValue)")
                    }
                }
            }
            
            Spacer()
            
            // Done Button
            Button(action: onClose) {
                HStack {
                    Spacer()
                    Text("Done")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(currentTheme == .glassy ? Color.primary : Color.white)
                    Spacer()
                }
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 7)
                        .fill(currentTheme == .glassy ? Color.white.opacity(0.25) : accentColor)
                )
            }
            .buttonStyle(.plain)
            .padding(.bottom, 2)
        }
    }
    
    // MARK: - Mini Visual Swatches
    @ViewBuilder
    private func themePreviewSwatch(for theme: AppTheme) -> some View {
        ZStack {
            switch theme {
            case .white:
                RoundedRectangle(cornerRadius: 4.5)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4.5)
                            .stroke(Color(red: 215/255, green: 215/255, blue: 218/255), lineWidth: 1)
                    )
                
                VStack(spacing: 2) {
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color(red: 24/255, green: 24/255, blue: 27/255))
                        .frame(width: 14, height: 2.5)
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color(red: 160/255, green: 160/255, blue: 165/255))
                        .frame(width: 10, height: 2)
                }
                
            case .cozy:
                RoundedRectangle(cornerRadius: 4.5)
                    .fill(Color(red: 247/255, green: 242/255, blue: 232/255))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4.5)
                            .stroke(Color(red: 220/255, green: 212/255, blue: 198/255), lineWidth: 1)
                    )
                
                VStack(spacing: 2) {
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color(red: 45/255, green: 41/255, blue: 38/255))
                        .frame(width: 14, height: 2.5)
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color(red: 175/255, green: 165/255, blue: 155/255))
                        .frame(width: 10, height: 2)
                }
                
            case .glassy:
                ZStack {
                    RoundedRectangle(cornerRadius: 4.5)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.35), Color.white.opacity(0.12)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 4.5)
                                .stroke(Color.white.opacity(0.4), lineWidth: 1)
                        )
                    
                    VStack(spacing: 2) {
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color.primary.opacity(0.8))
                            .frame(width: 14, height: 2.5)
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color.secondary.opacity(0.6))
                            .frame(width: 10, height: 2)
                    }
                }
            }
        }
        .frame(width: 26, height: 20)
        .shadow(color: Color.black.opacity(0.06), radius: 2, y: 1)
    }
}
