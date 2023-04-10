//
//  CustomTextField.swift
//  ClarkeEngineering
//
//  Created by Max Rome on 8/19/22.
//

import SwiftUI

/// Custom text field
struct CustomTextField: View {
    
    @Binding var text: String
    @State var isEditing: Bool = false
    @State var titleText: String?
    var placeholderText: String
    
    // MARK: - Main rendering function
    var body: some View {
        VStack {
            TextField(placeholderText, text: $text)
                .font(.system(size: 25, weight: .bold))
            Rectangle().frame(height: 1.5)
                .foregroundColor(isEditing ? .accentColor : Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
        }
    }
}
