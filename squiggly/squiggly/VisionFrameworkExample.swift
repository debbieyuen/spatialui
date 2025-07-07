//
//  VisionFrameworkExample.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/6/25.
//

import Vision

// Vision Coordinate Conversion, the point in Vision coordinate space (normalized 0-1)
// Vision coordinates are normalized (0-1) with origin at bottom-left
// UIKit coordinates have origin at top-left, we need to flip Y
// Returns an `ImageFile` object based on the `ClassifyImageRequest` results.
func classifyImage(url: URL) async throws -> ImageFile {
    var image = ImageFile(url: url)
    
    // Vision request to classify an image.
    let request = ClassifyImageRequest()
    
    // Perform the request on the image, and return an array of `ClassificationObservation` objects.
    let results = try await request.perform(on: url)
        // Use `hasMinimumPrecision` for a high-recall filter.
        .filter { $0.hasMinimumPrecision(0.1, forRecall: 0.8) }
        // Use `hasMinimumRecall` for a high-precision filter.
        // .filter { $0.hasMinimumRecall(0.01, forPrecision: 0.9) }
    
    // Add each classification identifier and its respective confidence level into the observations dictionary.
    for classification in results {
        image.observations[classification.identifier] = classification.confidence
    }
    
    return image
}
