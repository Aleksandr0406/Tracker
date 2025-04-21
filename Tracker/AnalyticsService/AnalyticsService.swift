//
//  AnalyticsService.swift
//  Tracker
//
//  Created by 1111 on 10.04.2025.
//

import AppMetricaCore

struct AnalyticsService {
    static func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: "") else { return }
        
        AppMetrica.activate(with: configuration)
    }
    
    static func report(eventName: String, params: [String : String]) {
        AppMetrica.reportEvent(name: eventName, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
