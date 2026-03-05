//
//  Achievement.swift
//  90AquaCore
//

import Foundation

struct Achievement: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let description: String
    let iconName: String
    let unlockedAt: Date?
    
    var isUnlocked: Bool { unlockedAt != nil }
}

enum AchievementType: String, CaseIterable {
    case streak7 = "streak_7"
    case streak14 = "streak_14"
    case streak30 = "streak_30"
    case fiveLiters = "five_liters"
    case threeLiters = "three_liters"
    case firstEntry = "first_entry"
    case tenEntries = "ten_entries"
    case hundredEntries = "hundred_entries"
    case thirtyDaysInApp = "thirty_days"
    
    var achievement: Achievement {
        switch self {
        case .streak7: return Achievement(id: rawValue, title: "Week Warrior", description: "7 days streak", iconName: "flame.fill", unlockedAt: nil)
        case .streak14: return Achievement(id: rawValue, title: "Two Weeks Strong", description: "14 days streak", iconName: "flame.fill", unlockedAt: nil)
        case .streak30: return Achievement(id: rawValue, title: "Monthly Master", description: "30 days streak", iconName: "flame.fill", unlockedAt: nil)
        case .fiveLiters: return Achievement(id: rawValue, title: "Hydration Hero", description: "5 liters in one day", iconName: "drop.triangle.fill", unlockedAt: nil)
        case .threeLiters: return Achievement(id: rawValue, title: "Triple Threat", description: "3 liters in one day", iconName: "drop.fill", unlockedAt: nil)
        case .firstEntry: return Achievement(id: rawValue, title: "First Drop", description: "Log your first water", iconName: "drop.fill", unlockedAt: nil)
        case .tenEntries: return Achievement(id: rawValue, title: "Getting Started", description: "10 hydration entries", iconName: "list.number", unlockedAt: nil)
        case .hundredEntries: return Achievement(id: rawValue, title: "Century Club", description: "100 hydration entries", iconName: "star.fill", unlockedAt: nil)
        case .thirtyDaysInApp: return Achievement(id: rawValue, title: "30 Day Tracker", description: "30 days in app", iconName: "calendar", unlockedAt: nil)
        }
    }
}
