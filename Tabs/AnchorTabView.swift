//
//  AnchorTabView.swift
//  ClarkeEngineering
//
//  Created by Max Rome on 8/19/22.
//

import SwiftUI

/// Anchor view
struct AnchorTabView: View {
    
    @ObservedObject var manager: PDFManager
    @State private var bottomPadding: CGFloat = 30
    
    // MARK: - Main rendering function
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            Spacer(minLength: 20)
            VStack(alignment: .leading, spacing: 30) {
                Text("Enter the general anchor information")
                    .font(.system(size: 22)).bold()
                    .padding(.horizontal)
                VStack(spacing: 35) {
                    CustomTextField(text: $manager.userInfo.anchor, placeholderText: "Anchor")
                    CustomTextField(text: $manager.userInfo.baseMaterial, placeholderText: "Base Material")
                    CustomTextField(text: $manager.userInfo.baseMaterialStrength, placeholderText: "Base Material Strength")
                    CustomTextField(text: $manager.userInfo.adhesive, placeholderText: "Adhesive")
                    CustomTextField(text: $manager.userInfo.drillDirection, placeholderText: "Drill Direction")
                }
                Spacer(minLength: bottomPadding)
            }.padding(30)
            Spacer(minLength: 100)
        })
        .onAppear(perform: {
            NotificationCenter.default.addObserver(forName: UIApplication.keyboardWillShowNotification, object: nil, queue: nil) { _ in
                bottomPadding = 250
            }
            NotificationCenter.default.addObserver(forName: UIApplication.keyboardWillHideNotification, object: nil, queue: nil) { _ in
                bottomPadding = 30
            }
        })
    }
}

// MARK: - Preview UI
struct AnchorTabView_Previews: PreviewProvider {
    static var previews: some View {
        AnchorTabView(manager: PDFManager())
    }
}
