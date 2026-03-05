//
//  HydrationEntry.swift
//  90AquaCore
//

import Foundation

struct HydrationEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var date: Date
    var amountML: Int
    var workoutIntensity: WorkoutIntensity?
    var note: String?
    
    init(id: UUID = UUID(), date: Date = Date(), amountML: Int, workoutIntensity: WorkoutIntensity? = nil, note: String? = nil) {
        self.id = id
        self.date = date
        self.amountML = amountML
        self.workoutIntensity = workoutIntensity
        self.note = note
    }
}
