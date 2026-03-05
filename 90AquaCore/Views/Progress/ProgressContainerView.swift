//
//  ProgressContainerView.swift
//  90AquaCore
//

import SwiftUI

struct ProgressContainerView: View {
    @ObservedObject var viewModel: AquaCoreViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        AchievementsView(viewModel: viewModel)
                    } label: {
                        Label("Achievements", systemImage: "trophy.fill")
                            .foregroundColor(.aquaDeep)
                    }
                    NavigationLink {
                        TimeGoalsView(viewModel: viewModel)
                    } label: {
                        Label("Time Goals", systemImage: "clock.fill")
                            .foregroundColor(.aquaDeep)
                    }
                    NavigationLink {
                        CalendarHistoryView(viewModel: viewModel)
                    } label: {
                        Label("Calendar", systemImage: "calendar")
                            .foregroundColor(.aquaDeep)
                    }
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [Color.white, Color.aquaBackground.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.aquaWater.opacity(0.1), lineWidth: 1)
                        )
                        .shadow(color: Color.aquaDeep.opacity(0.04), radius: 4, x: 0, y: 2)
                )
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(
                LinearGradient(
                    colors: [Color.aquaBackground, Color.aquaWater.opacity(0.04)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationTitle("Progress")
            .toolbarColorScheme(.light, for: .navigationBar)
        }
    }
}

#Preview {
    ProgressContainerView(viewModel: AquaCoreViewModel())
}
