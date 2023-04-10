//
//  UserInfo.swift
//  ClarkeEngineering
//
//  Created by Max Rome on 8/19/22.
//

import UIKit
import SwiftUI

/// User details model
class UserInfo: ObservableObject {
    
    @Published var address: String = ""
    @Published var clientName: String = ""
    @Published var date: String = ""
    @Published var inspector: String = ""
    @Published var testType: String = ""
    
    @Published var anchor: String = ""
    @Published var baseMaterial: String = ""
    @Published var baseMaterialStrength: String = ""
    @Published var adhesive: String = ""
    @Published var drillDirection: String = ""
    
    @Published var selectedImage: UIImage? = nil
    
    /// Dictionary data used to save the model on user defaults
    var dictionary: [String: Any] {
        [
            "address": address, "clientName": clientName, "date": date, "inspector": inspector, "testType": testType, "anchor": anchor, "baseMaterial": baseMaterial, "baseMaterialStrength": baseMaterialStrength, "adhesive": adhesive, "drillDirection": drillDirection
        ]
    }
    
    /// Initializer with dictionary
    convenience init(dictionary: [String: Any]) {
        self.init()
        address = dictionary["address"] as? String ?? ""
        clientName = dictionary["clientName"] as? String ?? ""
        date = dictionary["date"] as? String ?? ""
        inspector = dictionary["inspector"] as? String ?? ""
        testType = dictionary["testType"] as? String ?? ""
        
        anchor = dictionary["anchor"] as? String ?? ""
        baseMaterial = dictionary["baseMaterial"] as? String ?? ""
        baseMaterialStrength = dictionary["baseMaterialStrength"] as? String ?? ""
        adhesive = dictionary["adhesive"] as? String ?? ""
        drillDirection = dictionary["drillDirection"] as? String ?? ""
    }
    
    /// Defines when education entry is valid
    var isValid: Bool {
        !address.trimmingCharacters(in: .whitespaces).isEmpty
        && !clientName.trimmingCharacters(in: .whitespaces).isEmpty
        && !date.trimmingCharacters(in: .whitespaces).isEmpty
        && !inspector.trimmingCharacters(in: .whitespaces).isEmpty
        && !testType.trimmingCharacters(in: .whitespaces).isEmpty
        
        && !anchor.trimmingCharacters(in: .whitespaces).isEmpty
        && !baseMaterial.trimmingCharacters(in: .whitespaces).isEmpty
        && !baseMaterialStrength.trimmingCharacters(in: .whitespaces).isEmpty
        && !adhesive.trimmingCharacters(in: .whitespaces).isEmpty
        && !drillDirection.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
