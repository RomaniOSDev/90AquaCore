//
//  SettingsView.swift
//  90AquaCore
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.aquaDeep)
                    .padding(.horizontal)
                
                VStack(spacing: 0) {
                    SettingsRow(
                        icon: "star.fill",
                        title: "Rate Us",
                        subtitle: "Share your experience"
                    ) {
                        AppSettingsService.rateApp()
                    }
                    
                    Divider()
                        .padding(.leading, 56)
                    
                    SettingsRow(
                        icon: "lock.shield.fill",
                        title: "Privacy Policy",
                        subtitle: "How we handle your data"
                    ) {
                        AppSettingsService.openPrivacyPolicy()
                    }
                    
                    Divider()
                        .padding(.leading, 56)
                    
                    SettingsRow(
                        icon: "doc.text.fill",
                        title: "Terms of Service",
                        subtitle: "Usage terms and conditions"
                    ) {
                        AppSettingsService.openTermsOfService()
                    }
                }
                .aquaCard()
                .padding(.horizontal, 24)
            }
            .padding(.vertical, 24)
        }
        .background(
            LinearGradient(
                colors: [Color.aquaBackground, Color.aquaWater.opacity(0.04)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                colors: [Color.aquaWater.opacity(0.2), Color.aquaWater.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.aquaWater, .aquaDeep],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.aquaDeep)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.aquaWater)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.aquaWater.opacity(0.7))
            }
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SettingsView()
}
