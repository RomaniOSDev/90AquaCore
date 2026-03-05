//
//  RemindersView.swift
//  90AquaCore
//

import SwiftUI
import UserNotifications

struct RemindersView: View {
    @ObservedObject var viewModel: AquaCoreViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Reminders")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.aquaDeep)
                    .padding(.horizontal)
                
                VStack(spacing: 16) {
                    ForEach(viewModel.reminders) { reminder in
                        ReminderRow(
                            reminder: reminder,
                            onUpdate: { viewModel.updateReminder($0) }
                        )
                    }
                    
                    Button {
                        viewModel.addReminder()
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Reminder")
                        }
                        .foregroundColor(.aquaWater)
                        .frame(maxWidth: .infinity)
                        .padding()
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
            requestNotificationPermission()
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
}

struct ReminderRow: View {
    let reminder: ReminderItem
    let onUpdate: (ReminderItem) -> Void
    
    var body: some View {
        HStack {
            Toggle("", isOn: Binding(
                get: { reminder.isEnabled },
                set: { onUpdate(ReminderItem(id: reminder.id, isEnabled: $0, time: reminder.time)) }
            ))
            .tint(.aquaWater)
            
            DatePicker(
                "",
                selection: Binding(
                    get: { reminder.time },
                    set: { onUpdate(ReminderItem(id: reminder.id, isEnabled: reminder.isEnabled, time: $0)) }
                ),
                displayedComponents: .hourAndMinute
            )
            .labelsHidden()
            .colorMultiply(.aquaWater)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.9), Color.aquaBackground],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.aquaWater.opacity(0.15), lineWidth: 1)
                )
                .shadow(color: Color.aquaDeep.opacity(0.05), radius: 6, x: 0, y: 3)
        )
    }
}

#Preview {
    RemindersView(viewModel: AquaCoreViewModel())
}
