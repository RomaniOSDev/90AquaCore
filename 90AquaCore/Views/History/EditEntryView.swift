//
//  EditEntryView.swift
//  90AquaCore
//

import SwiftUI

struct EditEntryView: View {
    @ObservedObject var viewModel: AquaCoreViewModel
    let entry: HydrationEntry
    @Environment(\.dismiss) private var dismiss
    
    @State private var amount: Int
    @State private var selectedIntensity: WorkoutIntensity
    @State private var note: String
    @State private var date: Date
    
    private let presetAmounts = [100, 200, 300, 500, 750, 1000]
    
    init(viewModel: AquaCoreViewModel, entry: HydrationEntry) {
        self.viewModel = viewModel
        self.entry = entry
        _amount = State(initialValue: entry.amountML)
        _selectedIntensity = State(initialValue: entry.workoutIntensity ?? .rest)
        _note = State(initialValue: entry.note ?? "")
        _date = State(initialValue: entry.date)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Amount (ml)", selection: $amount) {
                        ForEach(presetAmounts, id: \.self) { a in
                            Text("\(a) ml").tag(a)
                        }
                    }
                    .pickerStyle(.wheel)
                    Stepper("\(amount) ml", value: $amount, in: 50...3000, step: 50)
                } header: {
                    Text("Amount")
                }
                
                Section {
                    DatePicker("Date & Time", selection: $date)
                        .tint(.aquaWater)
                }
                
                Section {
                    Picker("Intensity", selection: $selectedIntensity) {
                        ForEach(WorkoutIntensity.allCases, id: \.self) { i in
                            Text(i.displayName).tag(i)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    TextField("Note", text: $note, axis: .vertical)
                        .lineLimit(3...6)
                } header: {
                    Text("Note")
                }
                
                Section {
                    Button("Save") {
                        var updated = entry
                        updated.amountML = amount
                        updated.date = date
                        updated.workoutIntensity = selectedIntensity
                        updated.note = note.isEmpty ? nil : note
                        viewModel.updateEntry(updated)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [.aquaWater, .aquaDeep],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: Color.aquaWater.opacity(0.3), radius: 6, x: 0, y: 3)
                    )
                }
            }
            .scrollContentBackground(.hidden)
            .background(
                LinearGradient(
                    colors: [Color.aquaBackground, Color.aquaWater.opacity(0.04)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationTitle("Edit Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.aquaDeep)
                }
            }
            .tint(.aquaWater)
        }
    }
}
