import SwiftUI

// MARK: - Color Extensions
extension Color {
    static let brandPrimary = Color("BrandPrimary") // Fallback or Asset
    static let brandSecondary = Color("BrandSecondary")
    
    // Premium Colors
    static let premiumGold = Color(red: 1.0, green: 0.84, blue: 0.0) // #FFD700
    static let premiumDark = Color(red: 0.1, green: 0.1, blue: 0.15)
    
    static let premiumGradientStart = Color(red: 0.95, green: 0.80, blue: 0.0)
    static let premiumGradientEnd = Color(red: 1.0, green: 0.60, blue: 0.20)
}

// MARK: - View Modifiers
extension View {
    func premiumCardStyle() -> some View {
        self
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [.premiumGradientStart, .premiumGradientEnd],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
    }
    
    func glassEffect() -> some View {
        self
            .background(.ultraThinMaterial)
            .cornerRadius(12)
    }
}

// MARK: - Animation Extensions
extension Animation {
    static var premiumSpring: Animation {
        .spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0)
    }
}

