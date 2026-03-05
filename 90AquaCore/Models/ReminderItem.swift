//
//  ReminderItem.swift
//  90AquaCore
//

import Foundation

struct ReminderItem: Identifiable, Codable, Equatable {
    let id: UUID
    var isEnabled: Bool
    var time: Date
    
    init(id: UUID = UUID(), isEnabled: Bool = true, time: Date = Date()) {
        self.id = id
        self.isEnabled = isEnabled
        self.time = time
    }
}
