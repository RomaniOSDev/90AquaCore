//
//  TimeGoalsView.swift
//  90AquaCore
//

import SwiftUI

struct TimeGoalsView: View {
    @ObservedObject var viewModel: AquaCoreViewModel
    
    private let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .short
        return f
    }()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Time Goals")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.aquaDeep)
                    .padding(.horizontal)
                
                Text("Set goals like \"Drink 500 ml by 12:00\"")
                    .font(.subheadline)
                    .foregroundColor(.aquaWater)
                    .padding(.horizontal)
                
                VStack(spacing: 12) {
                    ForEach(viewModel.timeGoals) { goal in
                        TimeGoalRow(
                            goal: goal,
                            currentAmount: viewModel.amountBeforeTime(goal.targetTime, on: Date()),
                            onUpdate: { viewModel.updateTimeGoal($0) }
                        )
                    }
                    
                    Button {
                        viewModel.addTimeGoal()
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Time Goal")
                        }
                        .foregroundColor(.aquaWater)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.white, Color.aquaBackground.opacity(0.5)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.aquaWater.opacity(0.4), style: StrokeStyle(lineWidth: 2, dash: [6]))
                                )
                                .shadow(color: Color.aquaDeep.opacity(0.05), radius: 4, x: 0, y: 2)
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
    }
}

struct TimeGoalRow: View {
    let goal: TimeGoal
    let currentAmount: Int
    let onUpdate: (TimeGoal) -> Void
    
    private let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .short
        return f
    }()
    
    private var isMet: Bool {
        currentAmount >= goal.targetAmountML
    }
    
    var body: some View {
        HStack {
            Toggle("", isOn: Binding(
                get: { goal.isEnabled },
                set: { onUpdate(TimeGoal(id: goal.id, targetTime: goal.targetTime, targetAmountML: goal.targetAmountML, isEnabled: $0)) }
            ))
            .tint(.aquaWater)
            
            DatePicker("", selection: Binding(
                get: { goal.targetTime },
                set: { onUpdate(TimeGoal(id: goal.id, targetTime: $0, targetAmountML: goal.targetAmountML, isEnabled: goal.isEnabled)) }
            ), displayedComponents: .hourAndMinute)
            .labelsHidden()
            
            Text("\(goal.targetAmountML) ml")
                .font(.headline)
                .foregroundColor(.aquaDeep)
                .frame(width: 70, alignment: .trailing)
            
            if goal.isEnabled {
                Image(systemName: isMet ? "checkmark.circle.fill" : "drop.fill")
                    .foregroundColor(isMet ? Color.aquaWater : Color.aquaWater.opacity(0.5))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.8), Color.aquaBackground],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.aquaWater.opacity(0.12), lineWidth: 1)
                )
                .shadow(color: Color.aquaDeep.opacity(0.04), radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    TimeGoalsView(viewModel: AquaCoreViewModel())
}
