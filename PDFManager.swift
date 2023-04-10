//
//  PDFManager.swift
//  ClarkeEngineering
//
//  Created by Max Rome on 8/19/22.
//

import SwiftUI
import Foundation

// MARK: - Scale factor for the PDF template
enum ScaleFactorType: CGFloat {
    case thumbnail = 0.4
    case preview = 0.85
    case save = 2.9
}

/// Main class to build PDF files
class PDFManager: ObservableObject {
    
    /// Collect user details for the resume
    @Published var userInfo = UserInfo()
    
    /// Work experience details
    @Published var workExperience = [WorkExperience]()
    
    /// Short summary text. This text on the right is the placeholder
    static let summaryPlaceholder = "Write additional comments"
    @Published var summary: String = PDFManager.summaryPlaceholder
    
    /// Scale factor for the templates during grid view, preview and saving
    @Published var scaleFactor: ScaleFactorType = .thumbnail
    
    // MARK: - Init the manager with saved data
    init() {
        let userDefaults = UserDefaults.standard
        if let info = userDefaults.dictionary(forKey: "userInfo") {
            userInfo = UserInfo(dictionary: info)
        }
        if let experience = userDefaults.array(forKey: "workExperience") as? [[String: Any]] {
            experience.forEach { (dictionary) in
                workExperience.append(WorkExperience(dictionary: dictionary))
            }
        }
        summary = userDefaults.string(forKey: "comment") ?? PDFManager.summaryPlaceholder
    }
    
    // MARK: - Validate the details
    // Check if the user provided the minimum necessary details
    var isTemplateReady: Bool {
        userInfo.isValid && summary != PDFManager.summaryPlaceholder && summary.count > 0
    }
    
    // MARK: - Save current details to User Defaults
    func saveCurrentDetails() {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(userInfo.dictionary, forKey: "userInfo")
        userDefaults.setValue(workExperience.compactMap({ $0.dictionary }), forKey: "workExperience")
        userDefaults.setValue(summary, forKey: "comment")
        userDefaults.synchronize()
    }
}

// MARK: - Extension to help export a view as PDF
extension View {
    func exportToPDF(completion: @escaping (_ url: String?) -> Void) {
        let outputFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("resume.pdf")
        let pageSize = CGSize(width: AppConfig.pageWidth*2, height: AppConfig.pageHeight*2)
        let hostingController = UIHostingController(rootView: self)
        hostingController.view.frame = CGRect(origin: .zero, size: pageSize)
        guard let root = UIApplication.shared.windows.first?.rootViewController else { return }
        root.addChild(hostingController)
        root.view.insertSubview(hostingController.view, at: 0)
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))
        DispatchQueue.main.async {
            do {
                try pdfRenderer.writePDF(to: outputFileURL, withActions: { (context) in
                    context.beginPage()
                    hostingController.view.layer.render(in: context.cgContext)
                })
                if AppConfig.showSavedPDFLocation {
                    print("PDF file saved to:\n\(outputFileURL.path)")
                }
                completion(outputFileURL.path)
            } catch {
                print("Could not create PDF file: \(error.localizedDescription)")
                completion(nil)
            }
            hostingController.removeFromParent()
            hostingController.view.removeFromSuperview()
        }
    }
}
