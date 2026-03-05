//
//  AddEntryView.swift
//  90AquaCore
//

import SwiftUI

struct AddEntryView: View {
    @ObservedObject var viewModel: AquaCoreViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedAmount: Int = 300
    @State private var selectedIntensity: WorkoutIntensity = .rest
    @State private var note: String = ""
    
    private let presetAmounts: [(Int, String)] = [
        (100, "drop"),
        (250, "drop.fill"),
        (500, "drop.triangle.fill"),
        (750, "drop.circle.fill"),
        (1000, "drop.fill")
    ]
    
    private var previewProgress: Double {
        let newTotal = viewModel.todayTotal + selectedAmount
        let goal = viewModel.dailyGoal
        return goal > 0 ? min(1, Double(newTotal) / Double(goal)) : 0
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    amountSection
                    intensitySection
                    noteSection
                    previewSection
                    actionsSection
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
            }
            .background(
                LinearGradient(
                    colors: [Color.aquaBackground, Color.aquaWater.opacity(0.06)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationTitle("Add Water")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.aquaDeep)
                }
            }
            .toolbarColorScheme(.light, for: .navigationBar)
        }
        .tint(.aquaWater)
    }
    
    private var amountSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "drop.fill")
                    .font(.title3)
                    .foregroundStyle(
                        LinearGradient(colors: [.aquaWater, .aquaDeep], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                Text("How much?")
                    .font(.headline)
                    .foregroundColor(.aquaDeep)
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(presetAmounts, id: \.0) { amount, icon in
                    AmountChip(
                        amount: amount,
                        icon: icon,
                        isSelected: selectedAmount == amount
                    ) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            selectedAmount = amount
                        }
                    }
                }
            }
            
            HStack(spacing: 12) {
                Button {
                    withAnimation {
                        selectedAmount = max(50, selectedAmount - 50)
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color.aquaWater)
                }
                .disabled(selectedAmount <= 50)
                .opacity(selectedAmount <= 50 ? 0.4 : 1)
                
                Text("\(selectedAmount) ml")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.aquaDeep)
                    .frame(minWidth: 100)
                    .contentTransition(.numericText())
                
                Button {
                    withAnimation {
                        selectedAmount = min(3000, selectedAmount + 50)
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color.aquaWater)
                }
                .disabled(selectedAmount >= 3000)
                .opacity(selectedAmount >= 3000 ? 0.4 : 1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color.white, Color.aquaBackground.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.aquaWater.opacity(0.12), lineWidth: 1)
                )
                .shadow(color: Color.aquaDeep.opacity(0.06), radius: 12, x: 0, y: 6)
        )
    }
    
    private var intensitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "flame.fill")
                    .font(.caption)
                    .foregroundColor(.aquaWater)
                Text("Workout intensity")
                    .font(.headline)
                    .foregroundColor(.aquaDeep)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(WorkoutIntensity.allCases, id: \.self) { intensity in
                        IntensityChip(
                            intensity: intensity,
                            isSelected: selectedIntensity == intensity
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                selectedIntensity = intensity
                            }
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color.white, Color.aquaBackground.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.aquaWater.opacity(0.12), lineWidth: 1)
                )
                .shadow(color: Color.aquaDeep.opacity(0.06), radius: 12, x: 0, y: 6)
        )
    }
    
    private var noteSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Note (optional)")
                .font(.subheadline)
                .foregroundColor(.aquaDeep.opacity(0.8))
            
            TextField("Morning coffee, after workout...", text: $note, axis: .vertical)
                .lineLimit(2...4)
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.aquaBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.aquaWater.opacity(0.2), lineWidth: 1)
                        )
                )
                .tint(.aquaWater)
        }
    }
    
    private var previewSection: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(Color.aquaWater.opacity(0.2), lineWidth: 6)
                    .frame(width: 56, height: 56)
                Circle()
                    .trim(from: 0, to: previewProgress)
                    .stroke(Color.aquaWater, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .frame(width: 56, height: 56)
                    .rotationEffect(.degrees(-90))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("After adding")
                    .font(.caption)
                    .foregroundColor(.aquaWater)
                Text("\(viewModel.todayTotal + selectedAmount) ml")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.aquaDeep)
            }
            
            Spacer()
            
            if previewProgress >= 1 {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.aquaWater)
                    Text("Goal!")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.aquaWater)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.aquaWater.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.aquaWater.opacity(0.15), lineWidth: 1)
                )
        )
    }
    
    private var actionsSection: some View {
        VStack(spacing: 12) {
            Button {
                viewModel.addEntry(amount: selectedAmount, intensity: selectedIntensity, note: note.isEmpty ? nil : note)
                dismiss()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Add \(selectedAmount) ml")
                        .fontWeight(.semibold)
                }
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
    }
}

struct AmountChip: View {
    let amount: Int
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .white : .aquaWater)
                Text("\(amount)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(isSelected ? .white : .aquaDeep)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        isSelected
                        ? LinearGradient(colors: [.aquaWater, .aquaDeep], startPoint: .topLeading, endPoint: .bottomTrailing)
                        : LinearGradient(colors: [Color.white, Color.aquaBackground], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(isSelected ? Color.clear : Color.aquaWater.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

struct IntensityChip: View {
    let intensity: WorkoutIntensity
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(intensity.displayName)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .aquaDeep)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(
                            isSelected
                            ? LinearGradient(colors: [.aquaWater, .aquaDeep], startPoint: .leading, endPoint: .trailing)
                            : LinearGradient(colors: [Color.white.opacity(0.8), Color.aquaBackground], startPoint: .leading, endPoint: .trailing)
                        )
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.clear : Color.aquaWater.opacity(0.2), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AddEntryView(viewModel: AquaCoreViewModel())
}
