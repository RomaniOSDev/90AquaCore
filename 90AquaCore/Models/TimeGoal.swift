//
//  TimeGoal.swift
//  90AquaCore
//

import Foundation

struct TimeGoal: Identifiable, Codable, Equatable {
    let id: UUID
    var targetTime: Date
    var targetAmountML: Int
    var isEnabled: Bool
    
    init(id: UUID = UUID(), targetTime: Date = Date(), targetAmountML: Int = 500, isEnabled: Bool = true) {
        self.id = id
        self.targetTime = targetTime
        self.targetAmountML = targetAmountML
        self.isEnabled = isEnabled
    }
}
