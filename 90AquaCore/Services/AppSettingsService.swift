//
//  AppSettingsService.swift
//  90AquaCore
//

import SwiftUI
import StoreKit
import UIKit

enum AppSettingsService {
    static func openPrivacyPolicy() {
        if let url = URL(string: "https://www.termsfeed.com/live/888eb9f7-3380-4873-918f-29fbdb65a357") {
            UIApplication.shared.open(url)
        }
    }
    
    static func openTermsOfService() {
        if let url = URL(string: "https://www.termsfeed.com/live/54493032-55d6-4b4f-8dc6-5a094ee60304") {
            UIApplication.shared.open(url)
        }
    }
    
    static func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}
