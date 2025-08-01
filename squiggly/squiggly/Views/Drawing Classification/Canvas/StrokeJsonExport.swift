//
//  StrokeJsonExport.swift
//  squiggly
//
//  Created by Debbie Yuen on 8/1/25.
//

import Foundation
import SwiftUI

// Converts the strokes into JSON format
// Simple 3D point struct
struct Point3D: Codable {
    let x: Float
    let y: Float
    let z: Float
}

// Stroke format for export
struct SerializableStroke: Codable {
    let color: String // Optional: remove if not needed
    let points: [Point3D]
}

// Export functionality
extension PaintingCanvas {
    func exportStrokesToJSONFile() -> URL? {
        let serializableStrokes = allStrokes.map { stroke in
            SerializableStroke(
                color: stroke.color.description,
                points: stroke.points.map {
                    Point3D(x: $0.x, y: $0.y, z: $0.z)
                }
            )
        }

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        guard let data = try? encoder.encode(serializableStrokes) else {
            print("JSON encoding failed.")
            return nil
        }

        let filename = "strokes_\(UUID().uuidString.prefix(8)).json"
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Could not access Documents directory.")
            return nil
        }

        let fileURL = documentsURL.appendingPathComponent(filename)

        do {
            try data.write(to: fileURL)
            print("Stroke JSON saved to: \(fileURL)")
            return fileURL
        } catch {
            print("Failed to write JSON file: \(error)")
            return nil
        }
    }
}
