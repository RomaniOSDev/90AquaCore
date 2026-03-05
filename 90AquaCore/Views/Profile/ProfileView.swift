//
//  ProfileView.swift
//  90AquaCore
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: AquaCoreViewModel
    
    @State private var weightText: String = ""
    @State private var activityLevel: WorkoutIntensity = .moderate
    @State private var dailyGoalText: String = ""
    @State private var gender: Gender = .male
    @State private var temperatureLevel: TemperatureLevel = .normal
    @State private var restDayGoalText: String = ""
    @State private var workoutDayGoalText: String = ""
    @State private var showCalculatedAlert = false
    @State private var calculatedGoal: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.aquaDeep)
                    .padding(.horizontal)
                
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Weight (kg)")
                            .font(.subheadline)
                            .foregroundColor(.aquaDeep)
                        
                        TextField("70", text: $weightText)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.white, Color.aquaBackground],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.aquaWater.opacity(0.3), lineWidth: 1.5)
                                    )
                                    .shadow(color: Color.aquaDeep.opacity(0.05), radius: 4, x: 0, y: 2)
                            )
                            .tint(.aquaWater)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Gender")
                            .font(.subheadline)
                            .foregroundColor(.aquaDeep)
                        
                        Picker("Gender", selection: $gender) {
                            ForEach(Gender.allCases, id: \.self) { g in
                                Text(g.displayName).tag(g)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Temperature (affects water need)")
                            .font(.subheadline)
                            .foregroundColor(.aquaDeep)
                        
                        Picker("Temperature", selection: $temperatureLevel) {
                            ForEach(TemperatureLevel.allCases, id: \.self) { t in
                                Text(t.displayName).tag(t)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.aquaWater)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Default Activity Level")
                            .font(.subheadline)
                            .foregroundColor(.aquaDeep)
                        
                        Picker("Activity", selection: $activityLevel) {
                            ForEach(WorkoutIntensity.allCases, id: \.self) { level in
                                Text(level.displayName).tag(level)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.aquaWater)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Daily Goal (ml)")
                            .font(.subheadline)
                            .foregroundColor(.aquaDeep)
                        
                        TextField("2500", text: $dailyGoalText)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.white, Color.aquaBackground],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.aquaWater.opacity(0.3), lineWidth: 1.5)
                                    )
                                    .shadow(color: Color.aquaDeep.opacity(0.05), radius: 4, x: 0, y: 2)
                            )
                            .tint(.aquaWater)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Goals by Day Type")
                            .font(.subheadline)
                            .foregroundColor(.aquaDeep)
                        
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Rest Day")
                                    .font(.caption)
                                    .foregroundColor(.aquaWater)
                                TextField("2000", text: $restDayGoalText)
                                    .keyboardType(.numberPad)
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.aquaBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.aquaWater.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Workout Day")
                                    .font(.caption)
                                    .foregroundColor(.aquaWater)
                                TextField("2800", text: $workoutDayGoalText)
                                    .keyboardType(.numberPad)
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.aquaBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.aquaWater.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                            }
                        }
                    }
                    
                    Button {
                        let weight = Int(weightText) ?? 70
                        calculatedGoal = viewModel.calculateRecommendedGoal(weight: weight, intensity: activityLevel, gender: gender, temperature: temperatureLevel)
                        var profile = viewModel.profile
                        profile.weightKG = weight
                        profile.activityLevel = activityLevel
                        profile.dailyGoalML = calculatedGoal
                        profile.gender = gender
                        profile.temperatureLevel = temperatureLevel
                        profile.restDayGoalML = Int(restDayGoalText).flatMap { $0 > 0 ? $0 : nil }
                        profile.workoutDayGoalML = Int(workoutDayGoalText).flatMap { $0 > 0 ? $0 : nil }
                        viewModel.updateProfile(profile)
                        dailyGoalText = "\(calculatedGoal)"
                        showCalculatedAlert = true
                    } label: {
                        Text("Calculate Goal")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            colors: [.aquaWater, .aquaDeep],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: Color.aquaWater.opacity(0.4), radius: 8, x: 0, y: 4)
                                    .shadow(color: Color.aquaDeep.opacity(0.2), radius: 2, x: 0, y: 1)
                            )
                    }
                }
                .aquaCard()
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
        .onAppear {
            weightText = "\(viewModel.profile.weightKG)"
            activityLevel = viewModel.profile.activityLevel
            dailyGoalText = "\(viewModel.profile.dailyGoalML)"
            gender = viewModel.profile.gender
            temperatureLevel = viewModel.profile.temperatureLevel
            restDayGoalText = viewModel.profile.restDayGoalML.map { "\($0)" } ?? ""
            workoutDayGoalText = viewModel.profile.workoutDayGoalML.map { "\($0)" } ?? ""
        }
        .onChange(of: dailyGoalText) { _, newValue in
            if let value = Int(newValue), value > 0 {
                var p = viewModel.profile
                p.dailyGoalML = value
                viewModel.updateProfile(p)
            }
        }
        .onChange(of: weightText) { _, newValue in
            if let value = Int(newValue), value > 0 {
                var p = viewModel.profile
                p.weightKG = value
                viewModel.updateProfile(p)
            }
        }
        .onChange(of: activityLevel) { _, newValue in
            var p = viewModel.profile
            p.activityLevel = newValue
            viewModel.updateProfile(p)
        }
        .onChange(of: gender) { _, newValue in
            var p = viewModel.profile
            p.gender = newValue
            viewModel.updateProfile(p)
        }
        .onChange(of: temperatureLevel) { _, newValue in
            var p = viewModel.profile
            p.temperatureLevel = newValue
            viewModel.updateProfile(p)
        }
        .onChange(of: restDayGoalText) { _, newValue in
            if let v = Int(newValue), v > 0 {
                var p = viewModel.profile
                p.restDayGoalML = v
                viewModel.updateProfile(p)
            }
        }
        .onChange(of: workoutDayGoalText) { _, newValue in
            if let v = Int(newValue), v > 0 {
                var p = viewModel.profile
                p.workoutDayGoalML = v
                viewModel.updateProfile(p)
            }
        }
        .alert("Goal Calculated", isPresented: $showCalculatedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your recommended daily goal is \(calculatedGoal) ml")
        }
    }
}

#Preview {
    ProfileView(viewModel: AquaCoreViewModel())
}
