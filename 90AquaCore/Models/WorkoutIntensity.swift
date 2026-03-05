//
//  WorkoutIntensity.swift
//  90AquaCore
//

import Foundation

enum WorkoutIntensity: String, CaseIterable, Codable {
    case rest = "rest"
    case light = "light"
    case moderate = "moderate"
    case intense = "intense"
    case extreme = "extreme"
    
    var displayName: String {
        switch self {
        case .rest: return "Rest"
        case .light: return "Light"
        case .moderate: return "Moderate"
        case .intense: return "Intense"
        case .extreme: return "Extreme"
        }
    }
    
    var multiplier: Double {
        switch self {
        case .rest: return 1.0
        case .light: return 1.2
        case .moderate: return 1.4
        case .intense: return 1.6
        case .extreme: return 1.8
        }
    }
}
