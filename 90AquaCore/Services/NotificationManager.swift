//
//  NotificationManager.swift
//  90AquaCore
//

import UserNotifications

enum NotificationManager {
    static func scheduleHydrationReminder(id: UUID, time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "AquaCore"
        content.body = "Time to drink water!"
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    static func cancelReminder(id: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }
    
    static func updateReminder(_ item: ReminderItem) {
        cancelReminder(id: item.id)
        if item.isEnabled {
            scheduleHydrationReminder(id: item.id, time: item.time)
        }
    }
}
