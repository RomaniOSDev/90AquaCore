//
//  Gender.swift
//  90AquaCore
//

import Foundation

enum Gender: String, CaseIterable, Codable {
    case male = "male"
    case female = "female"
    
    var displayName: String {
        switch self {
        case .male: return "Male"
        case .female: return "Female"
        }
    }
    
    var baseMultiplier: Double {
        switch self {
        case .male: return 1.0
        case .female: return 0.9
        }
    }
}
