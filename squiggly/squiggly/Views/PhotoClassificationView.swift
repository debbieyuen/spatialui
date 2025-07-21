//
//  PhotoClassificationView.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/6/25.
//

import SwiftUI
import PhotosUI
import Vision

struct PhotoClassificationView: View {
    @StateObject private var classifier = ImageClassifier()
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: Image?

    var body: some View {
        VStack(spacing: 20) {
            // Button to choose an image
            PhotosPicker("Choose Image", selection: $selectedItem, matching: .images)
                .padding()
            
            // Show the image if available
            if let image = classifier.image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            
            // Show classification results
            if let observations = classifier.imageFile?.observations {
                List(observations.sorted(by: { $0.value > $1.value }), id: \.key) { key, confidence in
                    Text("\(key): \(confidence * 100, specifier: "%.1f")%")
                }
            } else {Text("No classifications yet").foregroundColor(.gray)}
        }
        .padding()
        .onChange(of: selectedItem) { oldItem, newItem in
            guard let newItem else { return }
              Task {
                  if let data = try? await newItem.loadTransferable(type: Data.self),
                     let uiImage = UIImage(data: data) {
                      selectedImage = Image(uiImage: uiImage)
                      await classifier.classifyImage(from: data)
                  }
              }
        }
    }
}
