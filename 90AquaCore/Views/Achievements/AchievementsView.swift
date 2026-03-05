//
//  AchievementsView.swift
//  90AquaCore
//

import SwiftUI

struct AchievementsView: View {
    @ObservedObject var viewModel: AquaCoreViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Achievements")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.aquaDeep)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Habit Progress")
                        .font(.headline)
                        .foregroundColor(.aquaDeep)
                    
                    HStack {
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.aquaWater.opacity(0.15), Color.aquaWater.opacity(0.25)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(height: 12)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        colors: [.aquaWater, .aquaDeep],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: CGFloat(viewModel.habitProgress) * 200, height: 12)
                                .shadow(color: Color.aquaWater.opacity(0.4), radius: 4, x: 0, y: 2)
                        }
                        .frame(width: 200)
                        
                        Text("\(Int(viewModel.habitProgress * 100))%")
                            .font(.headline)
                            .foregroundColor(.aquaWater)
                    }
                    
                    Text("30-day habit formation progress")
                        .font(.caption)
                        .foregroundColor(.aquaDeep.opacity(0.8))
                }
                .aquaCard()
                .padding(.horizontal)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(viewModel.achievements) { achievement in
                        AchievementCard(achievement: achievement)
                    }
                }
                .padding(.horizontal)
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

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? Color.aquaWater : Color.aquaWater.opacity(0.2))
                    .frame(width: 56, height: 56)
                
                Image(systemName: achievement.iconName)
                    .font(.title2)
                    .foregroundColor(achievement.isUnlocked ? .white : .aquaWater.opacity(0.5))
            }
            
            Text(achievement.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.aquaDeep)
                .multilineTextAlignment(.center)
            
            Text(achievement.description)
                .font(.caption)
                .foregroundColor(achievement.isUnlocked ? .aquaWater : .gray)
                .multilineTextAlignment(.center)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color.white, Color.aquaBackground.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.aquaWater.opacity(0.12), lineWidth: 1)
                )
                .shadow(color: Color.aquaDeep.opacity(0.08), radius: 8, x: 0, y: 4)
                .shadow(color: Color.aquaDeep.opacity(0.04), radius: 16, x: 0, y: 8)
        )
        .opacity(achievement.isUnlocked ? 1 : 0.8)
    }
}

#Preview {
    AchievementsView(viewModel: AquaCoreViewModel())
}
