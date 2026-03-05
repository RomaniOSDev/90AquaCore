//
//  TemperatureLevel.swift
//  90AquaCore
//

import Foundation

enum TemperatureLevel: String, CaseIterable, Codable {
    case cold = "cold"
    case normal = "normal"
    case warm = "warm"
    case hot = "hot"
    
    var displayName: String {
        switch self {
        case .cold: return "Cold"
        case .normal: return "Normal"
        case .warm: return "Warm"
        case .hot: return "Hot"
        }
    }
    
    var extraMultiplier: Double {
        switch self {
        case .cold: return 0.9
        case .normal: return 1.0
        case .warm: return 1.1
        case .hot: return 1.25
        }
    }
}
