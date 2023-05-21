//
//  CustomTextField.swift
//  ClarkeEngineering
//
//  Created by Max Rome on 8/19/22.
//

import SwiftUI

struct CustomTextField: View {
    
    @Binding var text: String
    @State var isEditing: Bool = false
    var placeholderText: String
    
    var body: some View {
        TextField(placeholderText, text: $text) { isEditing in
            self.isEditing = isEditing
        } onCommit: {
        }
        .font(.system(size: 20))
        .padding(10)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(self.isEditing ? Color.blue : Color.gray, lineWidth: 2)
        )
        .foregroundColor(self.isEditing ? Color.black : Color.black)
        .padding(.horizontal)
    }
}
