//
//  AquaDesign.swift
//  90AquaCore
//

import SwiftUI

struct AquaCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 20
    
    func body(content: Content) -> some View {
        content
            .padding(24)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white,
                                    Color.aquaBackground.opacity(0.95)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.9),
                                    Color.aquaWater.opacity(0.15)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                }
                .shadow(color: Color.aquaDeep.opacity(0.08), radius: 4, x: 0, y: 2)
                .shadow(color: Color.aquaDeep.opacity(0.12), radius: 16, x: 0, y: 8)
                .shadow(color: Color.aquaWater.opacity(0.06), radius: 24, x: 0, y: 12)
            )
    }
}

struct AquaPillModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [Color.white, Color.aquaBackground],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.aquaWater.opacity(0.12), lineWidth: 1)
                    )
                    .shadow(color: Color.aquaDeep.opacity(0.06), radius: 6, x: 0, y: 3)
                    .shadow(color: Color.aquaDeep.opacity(0.04), radius: 12, x: 0, y: 6)
            )
    }
}

struct AquaButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [.aquaWater, .aquaDeep],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                            .blendMode(.overlay)
                    )
                    .shadow(color: Color.aquaWater.opacity(0.5), radius: 12, x: 0, y: 6)
                    .shadow(color: Color.aquaDeep.opacity(0.35), radius: 20, x: 0, y: 10)
                    .shadow(color: Color.aquaDeep.opacity(0.2), radius: 4, x: 0, y: 2)
            )
    }
}

struct AquaSmallCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white,
                                Color.aquaWater.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.aquaWater.opacity(0.12), lineWidth: 1)
                    )
                    .shadow(color: Color.aquaDeep.opacity(0.07), radius: 8, x: 0, y: 4)
                    .shadow(color: Color.aquaDeep.opacity(0.04), radius: 16, x: 0, y: 8)
            )
    }
}

extension View {
    func aquaCard(cornerRadius: CGFloat = 20) -> some View {
        modifier(AquaCardModifier(cornerRadius: cornerRadius))
    }
    
    func aquaPill() -> some View {
        modifier(AquaPillModifier())
    }
    
    func aquaButton() -> some View {
        modifier(AquaButtonModifier())
    }
    
    func aquaSmallCard() -> some View {
        modifier(AquaSmallCardModifier())
    }
}
