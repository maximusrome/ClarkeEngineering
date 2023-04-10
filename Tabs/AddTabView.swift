//
//  AddTabView.swift
//  ClarkeEngineering
//
//  Created by Max Rome on 8/19/22.
//

import SwiftUI

/// Add tab
struct AddTabView: View {
    
    @ObservedObject var manager: PDFManager
    @State private var showAddWorkFlow: Bool = false
    @State private var showImagePicker = false
    
    // MARK: - Main rendering function
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            VStack(alignment: .center, spacing: 30) {
                VStack {
                    if manager.userInfo.selectedImage != nil {
                        ImageCanvas(image: $manager.userInfo.selectedImage, manager: manager)
                            .frame(width: UIScreen.main.bounds.width - 200, height: 600, alignment: .center)
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            self.showImagePicker = true
                        }, label: {
                            Text("Add Pictures")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
                                .background(Color.blue)
                                .cornerRadius(20)
                                .shadow(radius: 5)
                        })
                        .sheet(isPresented: $showImagePicker) {
                            ImagePicker(selectedImage: self.$manager.userInfo.selectedImage, isPresented: self.$showImagePicker, sourceType: .photoLibrary)
                        }
                        Spacer()
                    }
                }
                ForEach(0..<manager.workExperience.count, id: \.self, content: { id in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Anchor #\(id + 1)").bold()
                        }
                        Spacer()
                        Button(action: {
                            manager.workExperience.remove(at: id)
                        }, label: {
                            Image(systemName: "trash").foregroundColor(.red)
                        })
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.2), radius: 10)
                    )
                })
                Button(action: {
                    showAddWorkFlow = true
                }, label: {
                    Text("Add Anchors")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
                        .background(Color.blue)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                })
            }.padding(30)
        })
        .sheet(isPresented: $showAddWorkFlow, content: {
            AddWorkExperience(manager: manager)
        })
    }
}

struct PointWithID: Identifiable {
    static var count = 0
    let id = UUID()
    let point: CGPoint
    var number: Int
    
    init(point: CGPoint) {
        self.point = point
        PointWithID.count += 1
        self.number = PointWithID.count
    }
}

extension UIImage {
    func scaleFactorToFit(in size: CGSize) -> CGFloat {
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        return min(widthRatio, heightRatio)
    }
}

struct ImageCanvas: View {
    @Binding var image: UIImage?
    var manager: PDFManager
    @State private var points: [PointWithID] = []
    
    let squareSize = CGSize(width: 20, height: 20)
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    if image != nil {
                        Image(uiImage: modifiedImage(in: geometry.size, pointsToDraw: points))
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    }
                    Color.clear
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onEnded { value in
                                    let location = value.location
                                    points.append(PointWithID(point: location))
                                    manager.userInfo.selectedImage = modifiedImage(in: geometry.size, pointsToDraw: points)
                                }
                        )
                }
            }
        }
    }
    
    private func modifiedImage(in size: CGSize, pointsToDraw: [PointWithID]) -> UIImage {
        guard let originalImage = image else { return UIImage() }
        let scaleFactor = originalImage.scaleFactorToFit(in: size)
        return drawRectanglesOnImage(image: originalImage, points: pointsToDraw, squareSize: squareSize, scaleFactor: scaleFactor)
    }
    private func drawRectanglesOnImage(image: UIImage, points: [PointWithID], squareSize: CGSize, scaleFactor: CGFloat) -> UIImage {
        let imageSize = image.size
        let renderer = UIGraphicsImageRenderer(size: imageSize)
        
        let newImage = renderer.image { context in
            let cgContext = context.cgContext
            image.draw(in: CGRect(origin: .zero, size: imageSize))
            
            for pointWithID in points {
                let yOffset: CGFloat = 30
                let point = CGPoint(x: (pointWithID.point.x - 10) / scaleFactor, y: (pointWithID.point.y - yOffset) / scaleFactor)
                let number = pointWithID.number
                
                let rect = CGRect(origin: point, size: CGSize(width: squareSize.width / scaleFactor, height: squareSize.height / scaleFactor))
                cgContext.setStrokeColor(UIColor.red.cgColor)
                cgContext.setLineWidth(2 / scaleFactor)
                cgContext.stroke(rect)
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.red,
                    .font: UIFont.systemFont(ofSize: 14 / scaleFactor, weight: .bold),
                    .paragraphStyle: paragraphStyle
                ]
                
                let numberString = "\(number)"
                let attributedString = NSAttributedString(string: numberString, attributes: attributes)
                let stringSize = numberString.size(withAttributes: attributes)
                let stringOrigin = CGPoint(x: point.x + (squareSize.width / scaleFactor - stringSize.width) / 2, y: point.y + (squareSize.height / scaleFactor - stringSize.height) / 2)
                attributedString.draw(at: stringOrigin)
            }
        }
        return newImage
    }
}

struct AddWorkExperience: View {
    
    @ObservedObject var manager: PDFManager
    @ObservedObject var workModel = WorkExperience()
    @Environment(\.presentationMode) var presentation
    @State private var bottomPadding: CGFloat = 30
    
    @State private var showCamera = false
    @State private var image: UIImage?
    
    // MARK: - Main rendering function
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            Spacer(minLength: 20)
            VStack(alignment: .leading, spacing: 30) {
                Text("Anchor")
                    .font(.system(size: 22)).bold()
                VStack(spacing: 35) {
                    CustomTextField(text: $workModel.location, placeholderText: "Location")
                    CustomTextField(text: $workModel.load, placeholderText: "Load")
                    CustomTextField(text: $workModel.comment, placeholderText: "Comment")
                    HStack {
                        Text("Include picture?")
                            .font(.system(size: 22)).bold()
                        Spacer()
                        Toggle("", isOn: $workModel.pickPhoto).labelsHidden().accentColor(.accentColor)
                    }.padding(.bottom, 20)
                    if workModel.pickPhoto {
                        Button(action: {
                            showCamera = true
                        }, label: {
                            Text("Take Picture")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
                                .background(Color.blue)
                                .cornerRadius(20)
                                .shadow(radius: 5)
                        })
                        CustomTextField(text: $workModel.pictureComment, placeholderText: "Picture Comment")
                    }
                    Button(action: {
                        UIImpactFeedbackGenerator().impactOccurred()
                        if workModel.isValid {
                            if let image = image {
                                workModel.image = image
                            }
                            manager.workExperience.append(workModel)
                        }
                        presentation.wrappedValue.dismiss()
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .shadow(color: Color.black.opacity(0.3), radius: 8, y: 5)
                            Text("Save").font(.system(size: 24))
                                .foregroundColor(.white).bold()
                        }
                    }).frame(height: 60).padding([.leading, .trailing], 30)
                } .disableAutocorrection(true)
                Spacer(minLength: bottomPadding)
            }.padding(30)
            Spacer(minLength: 100)
        })
        .sheet(isPresented: $showCamera) {
            ImagePickerView(selectedImage: $image, isPresented: $showCamera, sourceType: .camera)
        }
        .onAppear(perform: {
            NotificationCenter.default.addObserver(forName: UIApplication.keyboardWillShowNotification, object: nil, queue: nil) { _ in
                bottomPadding = 80
            }
            NotificationCenter.default.addObserver(forName: UIApplication.keyboardWillHideNotification, object: nil, queue: nil) { _ in
                bottomPadding = 30
            }
        })
    }
}

// View for picking images from the photo library or camera
struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool
    let sourceType: UIImagePickerController.SourceType
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerView>) {
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePickerView
        
        init(parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}
