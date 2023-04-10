//
//  WorkExperience.swift
//  ClarkeEngineering
//
//  Created by Max Rome on 8/19/22.
//

import UIKit
import SwiftUI

/// Basic work experience details
class WorkExperience: ObservableObject {
    
    @Published var location: String = ""
    @Published var load: String = ""
    @Published var comment: String = ""
    
    @Published var pickPhoto: Bool = false
    @Published var pictureComment: String = ""
    @Published var image: UIImage? = nil
    
    /// Dictionary data used to save the model on user defaults
    var dictionary: [String: Any] {
        [
            "location": location, "load": load, "comment": comment,
            "pickPhoto": pickPhoto, "pictureComment": pictureComment
        ]
    }
    
    /// Initializer with dictionary
    convenience init(dictionary: [String: Any]) {
        self.init()
        location = dictionary["location"] as? String ?? ""
        load = dictionary["load"] as? String ?? ""
        comment = dictionary["comment"] as? String ?? ""
        pickPhoto = dictionary["pickPhoto"] as? Bool ?? false
        pictureComment = dictionary["pictureComment"] as? String ?? ""
    }
    
    /// Defines when a work experience entry is valid
    var isValid: Bool {
        !location.trimmingCharacters(in: .whitespaces).isEmpty
        && !load.trimmingCharacters(in: .whitespaces).isEmpty
        && !comment.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
