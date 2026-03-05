//
//  AquaCoreViewModel.swift
//  90AquaCore
//

import Foundation
import Combine
import SwiftUI

final class AquaCoreViewModel: ObservableObject {
    private enum StorageKeys {
        static let entries = "aquacore_entries"
        static let profile = "aquacore_profile"
        static let reminders = "aquacore_reminders"
        static let timeGoals = "aquacore_time_goals"
    }
    
    // MARK: - Published
    @Published var entries: [HydrationEntry] = []
    @Published var profile: UserProfile
    @Published var reminders: [ReminderItem] = []
    @Published var timeGoals: [TimeGoal] = []
    @Published var searchQuery: String = ""
    
    // MARK: - Computed
    var todayTotal: Int {
        todayEntries.reduce(0) { $0 + $1.amountML }
    }
    
    var dailyGoal: Int {
        if let rest = profile.restDayGoalML, let workout = profile.workoutDayGoalML {
            let hasWorkoutToday = todayEntries.contains { $0.workoutIntensity != nil && $0.workoutIntensity != .rest }
            return hasWorkoutToday ? workout : rest
        }
        let base = profile.dailyGoalML
        let tempMultiplier = profile.temperatureLevel.extraMultiplier
        let genderMultiplier = profile.gender.baseMultiplier
        return Int(Double(base) * tempMultiplier * genderMultiplier)
    }
    
    var progressPercentage: Double {
        guard dailyGoal > 0 else { return 0 }
        return min(1.0, Double(todayTotal) / Double(dailyGoal))
    }
    
    var todayProgress: Double {
        progressPercentage
    }
    
    var todayEntries: [HydrationEntry] {
        filterEntries(for: .day)
    }
    
    var weeklyAverages: [Int] {
        let calendar = Calendar.current
        var result: [Int] = []
        for dayOffset in (0..<7).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) else { continue }
            let dayEntries = entries.filter { calendar.isDate($0.date, inSameDayAs: date) }
            result.append(dayEntries.reduce(0) { $0 + $1.amountML })
        }
        return result
    }
    
    var bestStreak: Int {
        let calendar = Calendar.current
        let sortedDates = Set(entries.map { calendar.startOfDay(for: $0.date) }).sorted(by: >)
        guard !sortedDates.isEmpty else { return 0 }
        
        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())
        
        for entryDate in sortedDates {
            if calendar.isDate(entryDate, inSameDayAs: currentDate) {
                streak += 1
                guard let prevDate = calendar.date(byAdding: .day, value: -1, to: currentDate) else { break }
                currentDate = prevDate
            } else if entryDate < currentDate {
                break
            }
        }
        return streak
    }
    
    var monthlyTotal: Int {
        filterEntries(for: .month).reduce(0) { $0 + $1.amountML }
    }
    
    var averageDailyVolume: Int {
        let dailyEntries = Dictionary(grouping: entries) { Calendar.current.startOfDay(for: $0.date) }
        let totals = dailyEntries.values.map { $0.reduce(0) { $0 + $1.amountML } }
        guard !totals.isEmpty else { return 0 }
        return totals.reduce(0, +) / totals.count
    }
    
    var filteredEntries: [HydrationEntry] {
        let query = searchQuery.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else { return entries }
        let q = query.lowercased()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_US")
        return entries.filter { entry in
            (entry.note?.lowercased().contains(q) ?? false) ||
            "\(entry.amountML)".contains(q) ||
            (entry.workoutIntensity?.displayName.lowercased().contains(q) ?? false) ||
            dateFormatter.string(from: entry.date).lowercased().contains(q)
        }
    }
    
    var currentWeekTotal: Int {
        filterEntries(for: .weekOfYear).reduce(0) { $0 + $1.amountML }
    }
    
    var previousWeekTotal: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        guard let weekAgo = calendar.date(byAdding: .day, value: -7, to: today),
              let twoWeeksAgo = calendar.date(byAdding: .day, value: -14, to: today) else { return 0 }
        return entries.filter { entry in
            let day = calendar.startOfDay(for: entry.date)
            return day >= twoWeeksAgo && day < weekAgo
        }.reduce(0) { $0 + $1.amountML }
    }
    
    var achievements: [Achievement] {
        AchievementService.evaluateAchievements(
            entries: entries,
            bestStreak: bestStreak,
            firstLaunchDate: profile.firstAppLaunchDate
        )
    }
    
    var habitProgress: Double {
        guard let first = profile.firstAppLaunchDate else { return 0 }
        let days = Calendar.current.dateComponents([.day], from: first, to: Date()).day ?? 0
        guard days > 0 else { return 0 }
        let daysWithEntries = Set(entries.map { Calendar.current.startOfDay(for: $0.date) }).count
        return min(1.0, Double(daysWithEntries) / 30.0)
    }
    
    // MARK: - Init
    init() {
        self.profile = UserProfile()
        loadFromUserDefaults()
    }
    
    // MARK: - CRUD
    func addEntry(amount: Int, intensity: WorkoutIntensity?, note: String?) {
        let entry = HydrationEntry(amountML: amount, workoutIntensity: intensity, note: note?.isEmpty == true ? nil : note)
        entries.append(entry)
        entries.sort { $0.date > $1.date }
        saveToUserDefaults()
    }
    
    func deleteEntry(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        saveToUserDefaults()
    }
    
    func deleteEntry(_ entry: HydrationEntry) {
        entries.removeAll { $0.id == entry.id }
        saveToUserDefaults()
    }
    
    func updateEntry(_ entry: HydrationEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            entries.sort { $0.date > $1.date }
            saveToUserDefaults()
        }
    }
    
    func updateProfile(_ newProfile: UserProfile) {
        profile = newProfile
        saveToUserDefaults()
    }
    
    // MARK: - Reminders
    func addReminder() {
        reminders.append(ReminderItem())
        saveToUserDefaults()
    }
    
    func updateReminder(_ item: ReminderItem) {
        if let index = reminders.firstIndex(where: { $0.id == item.id }) {
            reminders[index] = item
            saveToUserDefaults()
            NotificationManager.updateReminder(item)
        }
    }
    
    func deleteReminder(at offsets: IndexSet) {
        reminders.remove(atOffsets: offsets)
        saveToUserDefaults()
    }
    
    // MARK: - Time Goals
    func addTimeGoal() {
        let calendar = Calendar.current
        let defaultTime = calendar.date(from: DateComponents(hour: 12, minute: 0)) ?? Date()
        timeGoals.append(TimeGoal(targetTime: defaultTime, targetAmountML: 500))
        saveToUserDefaults()
    }
    
    func updateTimeGoal(_ goal: TimeGoal) {
        if let index = timeGoals.firstIndex(where: { $0.id == goal.id }) {
            timeGoals[index] = goal
            saveToUserDefaults()
        }
    }
    
    func deleteTimeGoal(at offsets: IndexSet) {
        timeGoals.remove(atOffsets: offsets)
        saveToUserDefaults()
    }
    
    func amountBeforeTime(_ time: Date, on date: Date) -> Int {
        let calendar = Calendar.current
        return entries.filter {
            calendar.isDate($0.date, inSameDayAs: date) && $0.date <= time
        }.reduce(0) { $0 + $1.amountML }
    }
    
    // MARK: - Calculations
    func calculateRecommendedGoal(weight: Int, intensity: WorkoutIntensity, gender: Gender = .male, temperature: TemperatureLevel = .normal) -> Int {
        let base = weight * 30
        return Int(Double(base) * intensity.multiplier * gender.baseMultiplier * temperature.extraMultiplier)
    }
    
    func filterEntries(for period: Calendar.Component) -> [HydrationEntry] {
        let calendar = Calendar.current
        let now = Date()
        
        switch period {
        case .day:
            return entries.filter { calendar.isDateInToday($0.date) }
        case .weekOfYear, .weekOfMonth:
            guard let start = calendar.date(byAdding: .day, value: -7, to: now) else { return [] }
            return entries.filter { $0.date >= start }
        case .month:
            return entries.filter { calendar.isDate($0.date, equalTo: now, toGranularity: .month) }
        default:
            return entries
        }
    }
    
    // MARK: - Persistence
    func saveToUserDefaults() {
        if let entriesData = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(entriesData, forKey: StorageKeys.entries)
        }
        if let profileData = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(profileData, forKey: StorageKeys.profile)
        }
        if let remindersData = try? JSONEncoder().encode(reminders) {
            UserDefaults.standard.set(remindersData, forKey: StorageKeys.reminders)
        }
        if let goalsData = try? JSONEncoder().encode(timeGoals) {
            UserDefaults.standard.set(goalsData, forKey: StorageKeys.timeGoals)
        }
    }
    
    func loadFromUserDefaults() {
        if let entriesData = UserDefaults.standard.data(forKey: StorageKeys.entries),
           let decoded = try? JSONDecoder().decode([HydrationEntry].self, from: entriesData) {
            entries = decoded.sorted { $0.date > $1.date }
        }
        if let profileData = UserDefaults.standard.data(forKey: StorageKeys.profile),
           let decoded = try? JSONDecoder().decode(UserProfile.self, from: profileData) {
            profile = decoded
        }
        if let remindersData = UserDefaults.standard.data(forKey: StorageKeys.reminders),
           let decoded = try? JSONDecoder().decode([ReminderItem].self, from: remindersData) {
            reminders = decoded
            reminders.filter { $0.isEnabled }.forEach { NotificationManager.updateReminder($0) }
        } else if reminders.isEmpty {
            reminders = [ReminderItem(time: Calendar.current.date(from: DateComponents(hour: 9, minute: 0)) ?? Date())]
            saveToUserDefaults()
        }
        if let goalsData = UserDefaults.standard.data(forKey: StorageKeys.timeGoals),
           let decoded = try? JSONDecoder().decode([TimeGoal].self, from: goalsData) {
            timeGoals = decoded
        }
        if profile.firstAppLaunchDate == nil {
            var p = profile
            p.firstAppLaunchDate = Date()
            profile = p
            saveToUserDefaults()
        }
    }
}
