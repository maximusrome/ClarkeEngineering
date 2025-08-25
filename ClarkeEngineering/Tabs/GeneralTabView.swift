//
//  GeneralTabView.swift
//  ClarkeEngineering
//
//  Created by Max Rome on 8/19/22.
//

import SwiftUI

/// General tab
struct GeneralTabView: View {
    
    @ObservedObject var manager: PDFManager
    
    // MARK: - Main rendering function
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            VStack {
                Spacer(minLength: 20)
                VStack(alignment: .leading, spacing: 30) {
                    Text("Let's start with some general information")
                        .font(.system(size: 22)).bold()
                        .padding(.horizontal)
                    VStack(spacing: 35) {
                        CustomTextField(text: $manager.userInfo.address, placeholderText: "Address")
                        CustomTextField(text: $manager.userInfo.clientName, placeholderText: "Client Name")
                        CustomTextField(text: $manager.userInfo.date, placeholderText: "Date")
                        CustomTextField(text: $manager.userInfo.inspector, placeholderText: "Inspector")
                        CustomTextField(text: $manager.userInfo.testType, placeholderText: "Test Type")
                    }
                }.padding(30)
                Spacer()
            }
        })
    }
}

// MARK: - Preview UI
struct GeneralTabView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralTabView(manager: PDFManager())
    }
}
