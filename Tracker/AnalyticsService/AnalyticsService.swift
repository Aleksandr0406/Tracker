//
//  AnalyticsService.swift
//  Tracker
//
//  Created by 1111 on 10.04.2025.
//

import Foundation
import AppMetricaCore

struct AnalyticsService {
    static func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: "05d69593-fbd9-4418-8890-74073293884e") else { return }
        
        AppMetrica.activate(with: configuration)
    }
    
    static func report(eventName: String, params: [String : String]) {
        AppMetrica.reportEvent(name: eventName, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
