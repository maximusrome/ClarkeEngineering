//
//  ClarkeEngineeringApp.swift
//  ClarkeEngineering
//
//  Created by Max Rome on 7/14/22.
//

import Foundation
import SwiftUI

@main
struct ClarkeEngineering: App {
    
    @State private var didConfigureProject: Bool = false
    
    // MARK: - Main rendering function
    var body: some Scene {
        configureProject()
        return WindowGroup {
            DashboardContentView()
        }
    }
    
    /// One time configuration when the app launches
    private func configureProject() {
        DispatchQueue.main.async {
            if didConfigureProject == false {
                didConfigureProject = true
            }
        }
    }
}

/// Basic app configurations
class AppConfig {
    
    /// PDF Page size. We will be using the size below * `ScaleFactorType` value to increase the output quality
    static let pageWidth: Double = 8.5 * 75 /// U.S. letter size 8.5 x 11
    static let pageHeight: Double = 11 * 75 /// Multiply the size by 72 points per inch
    
    /// Turn this `true` to see the location where the PDF file is being saved on simulator
    static let showSavedPDFLocation: Bool = true
}
