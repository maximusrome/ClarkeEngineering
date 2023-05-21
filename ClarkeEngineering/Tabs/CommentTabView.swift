//
//  CommentTabView.swift
//  ClarkeEngineering
//
//  Created by Max Rome on 8/19/22.
//

import SwiftUI

/// Short summary
struct SummaryTabView: View {
    
    @ObservedObject var manager: PDFManager
    
    // MARK: - Main rendering function
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            Spacer(minLength: 20)
            VStack(alignment: .leading, spacing: 30) {
                Text("Additional Comments")
                    .font(.system(size: 22)).bold()
                TextEditor(text: $manager.summary)
                    .frame(height: UIScreen.main.bounds.height/3)
                    .foregroundColor(manager.summary == PDFManager.summaryPlaceholder ? .gray : .black)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).strokeBorder(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), lineWidth: 2))
                    .onTapGesture {
                        if manager.summary == PDFManager.summaryPlaceholder {
                            manager.summary = ""
                        }
                    }
            }.padding(30)
            Spacer(minLength: 100)
        })
    }
}

// MARK: - Preview UI
struct SummaryTabView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryTabView(manager: PDFManager())
    }
}
