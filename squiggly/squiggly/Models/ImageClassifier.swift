//
//  ImageClassifier.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/6/25.
//

import SwiftUI
import Vision
import UIKit

class ImageClassifier: ObservableObject {
    @Published var imageFile: ImageFile?
    @Published var image: Image? = nil

    func classifyImage(from data: Data) async {
        guard let uiImage = UIImage(data: data),
              let cgImage = uiImage.cgImage else {
            print("Invalid image data")
            return
        }

        var file = ImageFile(url: nil)

        let request = VNClassifyImageRequest()
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        do {
            try handler.perform([request])
            if let results = request.results as? [VNClassificationObservation] {
                for classification in results {
                    file.observations[classification.identifier] = classification.confidence
                }
            }
        } catch {
            print("Vision error: \(error)")
        }

        DispatchQueue.main.async {
            self.image = Image(uiImage: uiImage)
            self.imageFile = file
        }
    }
}
