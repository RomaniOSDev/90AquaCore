//
//  ContentView.swift
//  90AquaCore
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AquaCoreViewModel()
    @AppStorage("aquacore_onboarding_completed") private var hasCompletedOnboarding = false
    
    var body: some View {
        Group {
            if hasCompletedOnboarding {
                MainTabView(viewModel: viewModel)
            } else {
                OnboardingView(onComplete: {
                    withAnimation {
                        hasCompletedOnboarding = true
                    }
                })
            }
        }
    }
}

struct MainTabView: View {
    @ObservedObject var viewModel: AquaCoreViewModel
    
    var body: some View {
        TabView {
            HomeView(viewModel: viewModel)
                .tabItem {
                    Label("Home", systemImage: "drop.fill")
                }
            
            HistoryView(viewModel: viewModel)
                .tabItem {
                    Label("History", systemImage: "list.bullet")
                }
            
            StatisticsView(viewModel: viewModel)
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar.fill")
                }
            
            ProgressContainerView(viewModel: viewModel)
                .tabItem {
                    Label("Progress", systemImage: "trophy.fill")
                }
            
            ProfileView(viewModel: viewModel)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
            
            RemindersView(viewModel: viewModel)
                .tabItem {
                    Label("Reminders", systemImage: "bell.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(.aquaWater)
    }
}

#Preview {
    ContentView()
}
