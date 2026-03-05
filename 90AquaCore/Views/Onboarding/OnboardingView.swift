//
//  OnboardingView.swift
//  90AquaCore
//

import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
}

struct OnboardingView: View {
    let onComplete: () -> Void
    
    @State private var currentPage = 0
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "drop.fill",
            title: "Track Your Hydration",
            subtitle: "Log every glass of water and stay on top of your daily intake"
        ),
        OnboardingPage(
            icon: "chart.bar.fill",
            title: "Monitor Your Progress",
            subtitle: "View statistics, streaks, and insights to stay motivated"
        ),
        OnboardingPage(
            icon: "bell.badge.fill",
            title: "Stay Reminded",
            subtitle: "Set custom reminders and never forget to drink water"
        )
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.aquaBackground,
                    Color.aquaWater.opacity(0.08)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                        VStack(spacing: 32) {
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.aquaWater.opacity(0.2),
                                                Color.aquaWater.opacity(0.08)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 140, height: 140)
                                    .shadow(color: Color.aquaWater.opacity(0.2), radius: 20, x: 0, y: 10)
                                
                                Image(systemName: page.icon)
                                    .font(.system(size: 56))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.aquaWater, .aquaDeep],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            }
                            
                            VStack(spacing: 12) {
                                Text(page.title)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.aquaDeep)
                                    .multilineTextAlignment(.center)
                                
                                Text(page.subtitle)
                                    .font(.body)
                                    .foregroundColor(.aquaWater)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 32)
                            }
                            
                            Spacer()
                            Spacer()
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                VStack(spacing: 24) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.aquaWater : Color.aquaWater.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut(duration: 0.2), value: currentPage)
                        }
                    }
                    
                    Button {
                        if currentPage < pages.count - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            UserDefaults.standard.set(true, forKey: "aquacore_onboarding_completed")
                            onComplete()
                        }
                    } label: {
                        Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                LinearGradient(
                                    colors: [.aquaWater, .aquaDeep],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: Color.aquaWater.opacity(0.4), radius: 12, x: 0, y: 6)
                            .shadow(color: Color.aquaDeep.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
    }
}

#Preview {
    OnboardingView(onComplete: {})
}
