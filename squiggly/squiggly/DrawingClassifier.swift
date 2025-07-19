//
//  DrawingClassifier.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/18/25.
//

import UIKit
import CoreML

class DrawingClassifier {
    private let model: MNISTClassifier

    init() {
        do {
            self.model = try MNISTClassifier(configuration: MLModelConfiguration())
        } catch {
            fatalError("Failed to load MNIST model: \(error)")
        }
    }

    func classify(drawingImage: UIImage) -> String? {
        guard let pixelBuffer = drawingImage.toCVPixelBuffer() else {
            print("Failed to convert image to CVPixelBuffer")
            return nil
        }

        do {
            let prediction = try model.prediction(image: pixelBuffer)
            // get the classLabel digit as a string
            return String(prediction.classLabel)
        } catch {
            print("Prediction error: \(error)")
            return nil
        }
    }
}

