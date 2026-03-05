//
//  AchievementService.swift
//  90AquaCore
//

import Foundation

enum AchievementService {
    private static let storageKey = "aquacore_achievements"
    
    static func evaluateAchievements(entries: [HydrationEntry], bestStreak: Int, firstLaunchDate: Date?) -> [Achievement] {
        var achievements: [Achievement] = []
        let unlocked = loadUnlockedAchievements()
        let calendar = Calendar.current
        
        for type in AchievementType.allCases {
            var base = type.achievement
            if let date = unlocked[type.rawValue] {
                base = Achievement(id: base.id, title: base.title, description: base.description, iconName: base.iconName, unlockedAt: date)
            } else if shouldUnlock(type, entries: entries, bestStreak: bestStreak, firstLaunchDate: firstLaunchDate) {
                let now = Date()
                base = Achievement(id: base.id, title: base.title, description: base.description, iconName: base.iconName, unlockedAt: now)
                saveUnlock(type.rawValue, date: now)
            }
            achievements.append(base)
        }
        return achievements
    }
    
    private static func shouldUnlock(_ type: AchievementType, entries: [HydrationEntry], bestStreak: Int, firstLaunchDate: Date?) -> Bool {
        let calendar = Calendar.current
        
        switch type {
        case .streak7: return bestStreak >= 7
        case .streak14: return bestStreak >= 14
        case .streak30: return bestStreak >= 30
        case .fiveLiters:
            let dailyTotals = Dictionary(grouping: entries) { calendar.startOfDay(for: $0.date) }
            return dailyTotals.values.contains { $0.reduce(0) { $0 + $1.amountML } >= 5000 }
        case .threeLiters:
            let dailyTotals = Dictionary(grouping: entries) { calendar.startOfDay(for: $0.date) }
            return dailyTotals.values.contains { $0.reduce(0) { $0 + $1.amountML } >= 3000 }
        case .firstEntry: return !entries.isEmpty
        case .tenEntries: return entries.count >= 10
        case .hundredEntries: return entries.count >= 100
        case .thirtyDaysInApp:
            guard let first = firstLaunchDate else { return false }
            let days = calendar.dateComponents([.day], from: first, to: Date()).day ?? 0
            return days >= 30
        }
    }
    
    private static func loadUnlockedAchievements() -> [String: Date] {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([String: Date].self, from: data) else {
            return [:]
        }
        return decoded
    }
    
    private static func saveUnlock(_ id: String, date: Date) {
        var unlocked = loadUnlockedAchievements()
        unlocked[id] = date
        if let data = try? JSONEncoder().encode(unlocked) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}
