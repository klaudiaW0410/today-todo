import SwiftUI

// MARK: - Compact Theme Picker View
struct ThemePickerView: View {
    let currentTheme: AppTheme
    let accentColor: Color
    let onSelectTheme: (AppTheme) -> Void
    let onClose: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack(alignment: .center) {
                HStack(spacing: 5) {
                    Image(systemName: "paintpalette.fill")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(accentColor)
                    
                    Text("Select Theme")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(currentTheme.textPrimary)
                }
                
                Spacer()
                
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 8.5, weight: .bold))
                        .foregroundColor(currentTheme.textSecondary)
                        .padding(4)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .help("Close Theme Selector")
            }
            .padding(.bottom, 2)
            
            // Theme Options
            VStack(spacing: 5) {
                ForEach(AppTheme.allCases) { theme in
                    let isSelected = (theme == currentTheme)
                    
                    Button(action: {
                        onSelectTheme(theme)
                    }) {
                        HStack(spacing: 10) {
                            // Visual Swatch Preview
                            themePreviewSwatch(for: theme)
                            
                            // Title & Description
                            VStack(alignment: .leading, spacing: 1) {
                                HStack(spacing: 4) {
                                    Text(theme.displayName)
                                        .font(.system(size: 11.5, weight: isSelected ? .semibold : .medium))
                                        .foregroundColor(currentTheme.textPrimary)
                                    
                                    if isSelected {
                                        Text("Active")
                                            .font(.system(size: 8.5, weight: .semibold))
                                            .foregroundColor(accentColor)
                                            .padding(.horizontal, 4)
                                            .padding(.vertical, 1)
                                            .background(accentColor.opacity(0.12))
                                            .cornerRadius(3)
                                    }
                                }
                                
                                Text(theme.subtitle)
                                    .font(.system(size: 9.5, weight: .regular))
                                    .foregroundColor(currentTheme.textSecondary)
                            }
                            
                            Spacer()
                            
                            // Checkmark Indicator
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
                        .padding(.vertical, 6)
                        .padding(.horizontal, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 7)
                                .fill(isSelected ? currentTheme.surfaceMuted : Color.clear)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(isSelected ? accentColor.opacity(0.4) : currentTheme.borderSubtle.opacity(0.4), lineWidth: 0.8)
                        )
                    }
                    .buttonStyle(.plain)
                    .help("Switch to \(theme.displayName) theme")
                }
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(currentTheme == .glassy ? AnyShapeStyle(Color.white.opacity(0.12)) : AnyShapeStyle(currentTheme.surfaceMuted.opacity(0.85)))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(currentTheme.borderSubtle, lineWidth: 0.8)
        )
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
