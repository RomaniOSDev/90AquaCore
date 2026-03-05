//
//  UserProfile.swift
//  90AquaCore
//

import Foundation

struct UserProfile: Codable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case weightKG, activityLevel, dailyGoalML, gender, temperatureLevel
        case restDayGoalML, workoutDayGoalML, firstAppLaunchDate
    }
    
    var weightKG: Int
    var activityLevel: WorkoutIntensity
    var dailyGoalML: Int
    var gender: Gender
    var temperatureLevel: TemperatureLevel
    var restDayGoalML: Int?
    var workoutDayGoalML: Int?
    var firstAppLaunchDate: Date?
    
    var effectiveRestGoal: Int {
        restDayGoalML ?? dailyGoalML
    }
    
    var effectiveWorkoutGoal: Int {
        workoutDayGoalML ?? Int(Double(dailyGoalML) * 1.2)
    }
    
    init(
        weightKG: Int = 70,
        activityLevel: WorkoutIntensity = .moderate,
        dailyGoalML: Int = 2500,
        gender: Gender = .male,
        temperatureLevel: TemperatureLevel = .normal,
        restDayGoalML: Int? = nil,
        workoutDayGoalML: Int? = nil,
        firstAppLaunchDate: Date? = nil
    ) {
        self.weightKG = weightKG
        self.activityLevel = activityLevel
        self.dailyGoalML = dailyGoalML
        self.gender = gender
        self.temperatureLevel = temperatureLevel
        self.restDayGoalML = restDayGoalML
        self.workoutDayGoalML = workoutDayGoalML
        self.firstAppLaunchDate = firstAppLaunchDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        weightKG = try container.decodeIfPresent(Int.self, forKey: .weightKG) ?? 70
        activityLevel = try container.decodeIfPresent(WorkoutIntensity.self, forKey: .activityLevel) ?? .moderate
        dailyGoalML = try container.decodeIfPresent(Int.self, forKey: .dailyGoalML) ?? 2500
        gender = try container.decodeIfPresent(Gender.self, forKey: .gender) ?? .male
        temperatureLevel = try container.decodeIfPresent(TemperatureLevel.self, forKey: .temperatureLevel) ?? .normal
        restDayGoalML = try container.decodeIfPresent(Int.self, forKey: .restDayGoalML)
        workoutDayGoalML = try container.decodeIfPresent(Int.self, forKey: .workoutDayGoalML)
        firstAppLaunchDate = try container.decodeIfPresent(Date.self, forKey: .firstAppLaunchDate)
    }
}
