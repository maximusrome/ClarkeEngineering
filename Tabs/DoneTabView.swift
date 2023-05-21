//
//  DoneTabView.swift
//  ClarkeEngineering
//
//  Created by Max Rome on 8/19/22.
//

import SwiftUI
import UIKit

/// Last tab showing a list of PDF templates
struct DoneTabView: View {
    
    @ObservedObject var manager: PDFManager
    @State private var showShareSheet = false
    
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
            Spacer(minLength: 330)
            Button(action: {
                generatePDF()
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .shadow(color: Color.black.opacity(0.3), radius: 8, y: 5)
                    Text("Save PDF").font(.system(size: 24))
                        .foregroundColor(.white).bold()
                }
            }).frame(height: 60).padding(30)
        }).sheet(isPresented: $showShareSheet) {
            ActivityView(activityItems: [pdfURL as Any])
        }
    }
    private var pdfURL: URL {
        let fileName = "\(manager.userInfo.clientName).pdf"
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = directory.appendingPathComponent(fileName).appendingPathExtension("pdf")
        return fileURL as URL
    }
    
    private func generatePDF() {
        let format = UIGraphicsPDFRendererFormat()
        
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11.0 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        do {
            try renderer.writePDF(to: pdfURL) { context in
                let address = NSAttributedString(string: manager.userInfo.address, attributes: [.font: UIFont.boldSystemFont(ofSize: 20),.underlineStyle: NSUnderlineStyle.single.rawValue])
                let title = NSAttributedString(string: "Anchor Bolt Test Report", attributes: [.font: UIFont.boldSystemFont(ofSize: 20)])
                let client = NSAttributedString(string: "Client:", attributes: [.font: UIFont.systemFont(ofSize: 20)])
                let clientName = NSAttributedString(string: manager.userInfo.clientName, attributes: [.font: UIFont.boldSystemFont(ofSize: 20),.underlineStyle: NSUnderlineStyle.single.rawValue])
                let date = NSAttributedString(string: manager.userInfo.date, attributes: [.font: UIFont.systemFont(ofSize: 20)])
                let firstLine = NSMutableAttributedString(string: "20 NORTH BROADWAY, SUITE 1", attributes: [.font: UIFont.systemFont(ofSize: 15)])
                let secondLine = NSMutableAttributedString(string: "NYACK, NY 10960", attributes: [.font: UIFont.systemFont(ofSize: 15)])
                let thirdLine = NSMutableAttributedString(string: "845.353.6686", attributes: [.font: UIFont.systemFont(ofSize: 15)])
                let forthLine = NSMutableAttributedString(string: "WWW.CLARKENYC.COM", attributes: [.font: UIFont.systemFont(ofSize: 15)])
                let preparedBy = NSMutableAttributedString(string: "Prepared By: ",
                                                           attributes: [.font: UIFont.systemFont(ofSize: 20)])
                let inspectorName = NSAttributedString(string: manager.userInfo.inspector,
                                                       attributes: [.font: UIFont.systemFont(ofSize: 20)])
                
                preparedBy.append(NSAttributedString(attributedString: inspectorName))
                preparedBy.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 20), range: NSRange(location: 0, length: 12))
                
                context.beginPage()
                var pageCount = 1
                let pageNumberText = NSAttributedString(string: "Page \(pageCount) of 3", attributes: [.font: UIFont.systemFont(ofSize: 15)])
                let pageNumberRect = CGRect(x: pageWidth - 100, y: pageHeight - 50, width: 100, height: 50)
                pageNumberText.draw(in: pageNumberRect)
                
                if let logo = UIImage(named: "Clarke_Logo.jpg") {
                    logo.draw(in: CGRect(x: pageWidth / 2 - logo.size.width / 6, y: 340, width: logo.size.width / 3, height: logo.size.height / 3))
                }

                address.draw(at: CGPoint(x: pageWidth / 2 - address.size().width / 2, y: 50))
                title.draw(at: CGPoint(x: pageWidth / 2 - title.size().width / 2, y: 80))
                client.draw(at: CGPoint(x: pageWidth / 2 - client.size().width / 2, y: 155))
                clientName.draw(at: CGPoint(x: pageWidth / 2 - clientName.size().width / 2, y: 180))
                date.draw(at: CGPoint(x: pageWidth / 2 - date.size().width / 2, y: 210))
                firstLine.draw(at: CGPoint(x: pageWidth / 2 - firstLine.size().width / 2, y: 440))
                secondLine.draw(at: CGPoint(x: pageWidth / 2 - secondLine.size().width / 2, y: 460))
                thirdLine.draw(at: CGPoint(x: pageWidth / 2 - thirdLine.size().width / 2, y: 480))
                forthLine.draw(at: CGPoint(x: pageWidth / 2 - forthLine.size().width / 2, y: 500))
                preparedBy.draw(at: CGPoint(x: pageWidth / 2 - preparedBy.size().width / 2, y: 700))
                
                
                //page two
                let title2 = NSAttributedString(string: "Anchor Test Data Sheet", attributes: [.font: UIFont.boldSystemFont(ofSize: 20)])
                let company = NSAttributedString(string: "Company: ", attributes: [.font: UIFont.boldSystemFont(ofSize: 15)])
                let companyValue = NSAttributedString(string: "\(manager.userInfo.clientName)", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, .font: UIFont.systemFont(ofSize: 15)])
                let date1 = NSAttributedString(string: " Date: ", attributes: [.font: UIFont.boldSystemFont(ofSize: 15)])
                let dateValue = NSAttributedString(string: "\(manager.userInfo.date)", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, .font: UIFont.systemFont(ofSize: 15)])
                let companyDate = NSMutableAttributedString()
                companyDate.append(company)
                companyDate.append(companyValue)
                companyDate.append(date1)
                companyDate.append(dateValue)
                
                let testLocationTitle = NSAttributedString(string: "Test Location: ", attributes: [.font: UIFont.boldSystemFont(ofSize: 15)])
                let testLocationValue = NSAttributedString(string: "\(manager.userInfo.address)", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, .font: UIFont.systemFont(ofSize: 15)])
                let testLocation = NSMutableAttributedString()
                testLocation.append(testLocationTitle)
                testLocation.append(testLocationValue)
                
                let typeOfTestTitle = NSAttributedString(string: "Type of Test: ", attributes: [.font: UIFont.boldSystemFont(ofSize: 15)])
                let typeOfTestValue = NSAttributedString(string: "\(manager.userInfo.testType)", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, .font: UIFont.systemFont(ofSize: 15)])
                let testEquipmentTitle = NSAttributedString(string: " Test Equipment: ", attributes: [.font: UIFont.boldSystemFont(ofSize: 15)])
                let testEquipmentValue = NSAttributedString(string: "Hydrajaws Tester 2000", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, .font: UIFont.systemFont(ofSize: 15)])
                let typeOfTestEquipment = NSMutableAttributedString()
                typeOfTestEquipment.append(typeOfTestTitle)
                typeOfTestEquipment.append(typeOfTestValue)
                typeOfTestEquipment.append(testEquipmentTitle)
                typeOfTestEquipment.append(testEquipmentValue)
                
                let preparedByTitle = NSAttributedString(string: "Prepared By: ", attributes: [.font: UIFont.boldSystemFont(ofSize: 15)])
                let preparedByValue = NSAttributedString(string: "\(manager.userInfo.inspector)", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, .font: UIFont.systemFont(ofSize: 15)])
                let preparedBy2 = NSMutableAttributedString()
                preparedBy2.append(preparedByTitle)
                preparedBy2.append(preparedByValue)
                
                context.beginPage()
                pageCount = 2
                let pageNumberText2 = NSAttributedString(string: "Page \(pageCount) of 3", attributes: [.font: UIFont.systemFont(ofSize: 15)])
                let pageNumberRect2 = CGRect(x: pageWidth - 100, y: pageHeight - 50, width: 100, height: 50)
                pageNumberText2.draw(in: pageNumberRect2)
                
                let footer = NSAttributedString(string: "The test locations and loading conditions were at the direction of the above Company. Results indicate the tested anchor(s) held\nthe stated load for the time applied. Error allowance on calibrated equipment is +/- 2%. Testing does not: evaluate suitability or\nadequacy of the anchorage design; verify proper installation or ultimate capacity (unless otherwise noted) of tested anchors; or\naddress performance of untested anchors. Testing does not imply any agreement in or endorsement of the suitability of the anchor\nfor the application tested. Refer to the anchor manufacturers technical information for installation instructions, anchorage design\nprinciples and performance criteria. Proper installation of anchors is critical!", attributes: [.font: UIFont.systemFont(ofSize: 8)])
                if let logo = UIImage(named: "Clarke_Logo.jpg") {
                    logo.draw(in: CGRect(x: pageWidth / 2 - logo.size.width / 6, y: 50, width: logo.size.width / 3, height: logo.size.height / 3))
                }
                title2.draw(at: CGPoint(x: pageWidth / 2 - title2.size().width / 2, y: 130))
                companyDate.draw(at: CGPoint(x: 40, y: 180))
                testLocation.draw(at: CGPoint(x: 40, y: 205))
                typeOfTestEquipment.draw(at: CGPoint(x: 40, y: 230))
                preparedBy2.draw(at: CGPoint(x: 40, y: 255))
                footer.draw(at: CGPoint(x: 40, y: pageHeight - 120))
                
                // Create table
                let tableRect = CGRect(x: 36, y: pageHeight - 500, width: pageWidth - 72, height: 50)
                let numberOfRows = 2
                let numberOfColumns = 5
                let columnWidth = tableRect.width / CGFloat(numberOfColumns)
                let rowHeight = tableRect.height / CGFloat(numberOfRows)
                let arr = ["Anchor", "Base Material", "Base Strength", "Adhesive", "Drill Dir.", manager.userInfo.anchor, manager.userInfo.baseMaterial, manager.userInfo.baseMaterialStrength, manager.userInfo.adhesive, manager.userInfo.drillDirection]
                
                let padding: CGFloat = 6 // Set the desired padding value
                
                var index = 0
                for row in 0..<numberOfRows {
                    for column in 0..<numberOfColumns {
                        let cellRect = CGRect(x: tableRect.minX + CGFloat(column) * columnWidth, y: tableRect.minY + CGFloat(row) * rowHeight, width: columnWidth, height: rowHeight)
                        
                        // Add padding to cell rect
                        let paddedCellRect = cellRect.insetBy(dx: padding, dy: padding)
                        
                        // Fill cell with text
                        let text = "\(arr[index])"
                        
                        // Choose the font based on whether the text should be bold or not
                        let font: UIFont
                        if index < 5 {
                            font = UIFont.boldSystemFont(ofSize: 12)
                        } else {
                            font = UIFont.systemFont(ofSize: 12)
                        }
                        
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.alignment = .center

                        let textAttributes = [
                            NSAttributedString.Key.font: font,
                            NSAttributedString.Key.foregroundColor: UIColor.black,
                            NSAttributedString.Key.paragraphStyle: paragraphStyle
                        ]
                        let attributedText = NSAttributedString(string: text, attributes: textAttributes)
                        attributedText.draw(in: paddedCellRect)
                        
                        // Add borders to cell
                        context.cgContext.setStrokeColor(UIColor.black.cgColor)
                        context.cgContext.stroke(cellRect)
                        
                        index += 1
                    }
                }
                
                //Anchor table
                
                let tableRect2 = CGRect(x: 36, y: pageHeight - 425, width: pageWidth - 72, height: CGFloat(manager.workExperience.count + 1) * 30.0)
                let numberOfRows2 = manager.workExperience.count + 1
                let numberOfColumns2 = 4
                
                let columnWidths2: [CGFloat] = [40, 320, 80, 100]
                
                // Define header titles
                let headers = ["#", "Location", "Load (lbf)", "Comment"]
                
                // Define cell content
                var content: [[String]] = [[String]]()
                for (index, experience) in manager.workExperience.enumerated() {
                    content.append([String(index + 1), experience.location, experience.load, experience.comment])
                }
                
                // Add headers to content array
                content.insert(headers, at: 0)
                
                var rowHeights: [CGFloat] = []
                for rowContent in content {
                    var maxHeight: CGFloat = 0
                    for (index, text) in rowContent.enumerated() {
                        let columnWidth = columnWidths2[index] - 2 * padding
                        let textAttributes: [NSAttributedString.Key: Any] = [
                            .font: UIFont.systemFont(ofSize: 12)
                        ]
                        let size = CGSize(width: columnWidth, height: .greatestFiniteMagnitude)
                        let textRect = (text as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
                        maxHeight = max(maxHeight, textRect.height)
                    }
                    rowHeights.append(maxHeight + 2 * padding)
                }
                // Loop through each cell and draw content and borders
                for row in 0..<numberOfRows2 {
                    for column in 0..<numberOfColumns2 {
                        let rowHeight = rowHeights[row]
                        let cellRect = CGRect(x: tableRect2.minX + columnWidths2[0..<column].reduce(0, +), y: tableRect2.minY + rowHeights[0..<row].reduce(0, +), width: columnWidths2[column], height: rowHeight)
                        
                        // Add padding to cell rect
                        let paddedCellRect = cellRect.insetBy(dx: padding, dy: padding)
                        
                        // Fill cell with text
                        var textAttributes = [
                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                            NSAttributedString.Key.foregroundColor: UIColor.black
                        ]
                        if row == 0 && (column == 1 || column == 3) {
                            // Bold header row and center-align elements
                            textAttributes[.font] = UIFont.boldSystemFont(ofSize: 12)
                            let paragraphStyle = NSMutableParagraphStyle()
                            paragraphStyle.alignment = .center
                            textAttributes[.paragraphStyle] = paragraphStyle
                        } else if row == 0 && column == 2 {
                            // Bold load header text and center-align
                            textAttributes[.font] = UIFont.boldSystemFont(ofSize: 12)
                            let paragraphStyle = NSMutableParagraphStyle()
                            paragraphStyle.alignment = .center
                            textAttributes[.paragraphStyle] = paragraphStyle
                        } else if column == 0 {
                            // Bold numbers in first column and center-align
                            textAttributes[.font] = UIFont.boldSystemFont(ofSize: 12)
                            let paragraphStyle = NSMutableParagraphStyle()
                            paragraphStyle.alignment = .center
                            textAttributes[.paragraphStyle] = paragraphStyle
                        } else if column == 1 {
                            // Left-align location text
                            let paragraphStyle = NSMutableParagraphStyle()
                            paragraphStyle.alignment = .left
                            textAttributes[.paragraphStyle] = paragraphStyle
                        } else if column == 2 {
                            // Center-align and unbold load text
                            let paragraphStyle = NSMutableParagraphStyle()
                            paragraphStyle.alignment = .center
                            textAttributes[.paragraphStyle] = paragraphStyle
                        } else if column == 3 {
                            // Bold comment header and left-align
                            if row == 0 {
                                textAttributes[.font] = UIFont.boldSystemFont(ofSize: 12)
                            } else {
                                let paragraphStyle = NSMutableParagraphStyle()
                                paragraphStyle.alignment = .left
                                textAttributes[.paragraphStyle] = paragraphStyle
                            }
                        }
                        
                        let text = "\(content[row][column])"
                        let attributedText = NSAttributedString(string: text, attributes: textAttributes)
                        attributedText.draw(in: paddedCellRect)
                        
                        // Add borders to cell
                        context.cgContext.setStrokeColor(UIColor.black.cgColor)
                        context.cgContext.stroke(cellRect)
                    }
                }
                context.beginPage()
                pageCount = 3
                let pageNumberText3 = NSAttributedString(string: "Page \(pageCount) of 3", attributes: [.font: UIFont.systemFont(ofSize: 15)])
                let pageNumberRect3 = CGRect(x: pageWidth - 100, y: pageHeight - 50, width: 100, height: 50)
                pageNumberText3.draw(in: pageNumberRect3)
                
                var boxHeight: CGFloat = 200.0 // initial box height
                let boxPadding: CGFloat = 20.0 // padding around text inside box
                
                // Bold "Additional Comments:"
                let boldText = "Additional Comments:\n\n"
                let boldAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 15)
                ]
                let boldAttributedText = NSAttributedString(string: boldText, attributes: boldAttributes)
                
                // Unbolded comment text
                let unboldedText = manager.summary
                let unboldedAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 15)
                ]
                let unboldedAttributedText = NSAttributedString(string: unboldedText, attributes: unboldedAttributes)
                
                let combinedAttributedString = NSMutableAttributedString()
                combinedAttributedString.append(boldAttributedText)
                combinedAttributedString.append(unboldedAttributedText)
                
                let commentSize = combinedAttributedString.boundingRect(with: CGSize(width: pageWidth - 80, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
                boxHeight = commentSize.height + 2.0 * boxPadding
                
                let boxRect = CGRect(x: 30, y: 75, width: pageWidth - 60, height: boxHeight)
                let boxPath = UIBezierPath(rect: boxRect)
                boxPath.lineWidth = 1.0
                UIColor.black.setStroke()
                boxPath.stroke()
                
                let commentOrigin = CGPoint(x: 40, y: 75 + boxPadding)
                combinedAttributedString.draw(with: CGRect(origin: commentOrigin, size: commentSize), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
                if let image = manager.userInfo.selectedImage {
                    let imageAspectRatio = image.size.width / image.size.height
                    let frameAspectRatio = pageWidth / pageHeight
                    
                    var imageWidth: CGFloat
                    var imageHeight: CGFloat
                    if imageAspectRatio > frameAspectRatio {
                        // Image is wider than the frame, so set the width to match the frame and calculate the height accordingly
                        imageWidth = pageWidth / 1.2
                        imageHeight = imageWidth / imageAspectRatio
                    } else {
                        // Image is taller than the frame, so set the height to match the frame and calculate the width accordingly
                        imageHeight = pageHeight / 1.2
                        imageWidth = imageHeight * imageAspectRatio
                    }
                    
                    let centerX = pageWidth / 2 - imageWidth / 2 // Center x coordinate of the image
                    let centerY = pageHeight / 2 - imageHeight / 2 // Center y coordinate of the image
                    let imageRect = CGRect(x: centerX, y: centerY + 40, width: imageWidth, height: imageHeight)
                    image.draw(in: imageRect)
                }
                let locationMap = NSAttributedString(string: "Location Map", attributes: [.font: UIFont.boldSystemFont(ofSize: 20),.underlineStyle: NSUnderlineStyle.single.rawValue])
                locationMap.draw(at: CGPoint(x: pageWidth / 2 - locationMap.size().width / 2, y: 620))
                footer.draw(at: CGPoint(x: 40, y: pageHeight - 120))
                
//                context.beginPage()
//                let origin = CGPoint(x: 50, y: 50) // Adjust the y-coordinate to position the table on the page
//                let rowHeightP: CGFloat = 200.0 // Adjust the row height as needed
//                let columnWidths = [CGFloat((pageWidth - 100) / 2 ), CGFloat((pageWidth - 100) / 2 )] // Adjust the column widths as needed
//                //let padding: CGFloat = 5.0 // Adjust the padding as needed
//                var yPosition = origin.y
//
//                for workExperience in manager.workExperience {
//                    if let image = workExperience.image {
//                        // Draw the image
//                        let imageSize = image.size
//                        _ = imageSize.width / imageSize.height
//                        let availableWidth = columnWidths[0] - 2 * padding
//                        let availableHeight = rowHeightP - 2 * padding
//                        var imageRect = CGRect.zero
//                        if imageSize.width > availableWidth || imageSize.height > availableHeight {
//                            let targetAspectRatio = min(availableWidth / imageSize.width, availableHeight / imageSize.height)
//                            let targetSize = CGSize(width: imageSize.width * targetAspectRatio, height: imageSize.height * targetAspectRatio)
//                            let x = origin.x + columnWidths[0] / 2 - targetSize.width / 2
//                            let y = yPosition + rowHeightP / 2 - targetSize.height / 2
//                            imageRect = CGRect(origin: CGPoint(x: x, y: y), size: targetSize)
//                        } else {
//                            let x = origin.x + columnWidths[0] / 2 - imageSize.width / 2
//                            let y = yPosition + rowHeightP / 2 - imageSize.height / 2
//                            imageRect = CGRect(origin: CGPoint(x: x, y: y), size: imageSize)
//                        }
//                        image.draw(in: imageRect)
//
//                        // Draw the picture comment
//                        let commentOrigin = CGPoint(x: origin.x + columnWidths[0] + padding, y: yPosition + padding)
//                        let commentText = workExperience.pictureComment as NSString
//                        let attributes: [NSAttributedString.Key: Any] = [            .foregroundColor: UIColor.black,            .font: UIFont.systemFont(ofSize: 14)        ]
//                        commentText.draw(at: commentOrigin, withAttributes: attributes)
//
//                        // Draw table lines
//                        let cgContext = context.cgContext
//                        cgContext.move(to: CGPoint(x: origin.x, y: yPosition))
//                        cgContext.addLine(to: CGPoint(x: origin.x, y: yPosition + rowHeightP))
//                        cgContext.addLine(to: CGPoint(x: origin.x + columnWidths.reduce(0, +), y: yPosition + rowHeightP))
//                        cgContext.addLine(to: CGPoint(x: origin.x + columnWidths.reduce(0, +), y: yPosition))
//                        cgContext.closePath()
//                        cgContext.strokePath()
//
//                        cgContext.move(to: CGPoint(x: origin.x + columnWidths[0], y: yPosition))
//                        cgContext.addLine(to: CGPoint(x: origin.x + columnWidths[0], y: yPosition + rowHeightP))
//                        cgContext.strokePath()
//
//                        // Update the y-position for the next image
//                        yPosition += rowHeightP + 20
//                    }
//                }
            }
            showShareSheet = true
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return activityViewController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool
    let sourceType: UIImagePickerController.SourceType
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Do nothing
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.selectedImage = selectedImage
            }
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}

// MARK: - Preview UI
struct DoneTabView_Previews: PreviewProvider {
    static var previews: some View {
        DoneTabView(manager: PDFManager())
    }
}
