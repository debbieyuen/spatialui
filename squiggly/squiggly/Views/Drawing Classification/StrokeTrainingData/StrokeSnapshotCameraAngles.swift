//
//  StrokeSnapshotCameraAngles.swift
//  squiggly
//
//  Created by Debbie Yuen on 8/1/25.
//

//
//  StrokeSnapshotCameraAngles.swift
//  squiggly
//
//  Created by Debbie Yuen on 8/1/25. Updated with camera framing.
//

import Foundation
import RealityKit
import UIKit

func takeSnapshotsFromMultipleAngles(sceneRoot: Entity, allStrokes: [Stroke]) async -> [URL] {
    var savedImageURLs: [URL] = []

    do {
        let renderer = try await OffscreenRenderModel(sceneRoot: sceneRoot)

        // Compute stroke bounds
        let (center, extent) = computeStrokeBounds(from: allStrokes)
        let maxExtent = max(extent.x, extent.y, extent.z)
        // Calculate the distance - stand a bit farther back from drawing
        let cameraDistance: Float = maxExtent * 2.0
        
        let directions: [(name: String, offset: SIMD3<Float>)] = [
            ("front",     SIMD3<Float>(-1,  0,  0)),
            ("back",      SIMD3<Float>( 1,  0,  0)),
            ("left",      SIMD3<Float>( 0,  0, -1)),
            ("right",     SIMD3<Float>( 0,  0,  1)),
            ("top",       SIMD3<Float>( 0,  1,  0)),
            ("bottom",    SIMD3<Float>( 0, -1,  0)),
            ("oblique1",  normalize(SIMD3<Float>(-1,  1,  0))),
            ("oblique2",  normalize(SIMD3<Float>(-1, -1,  0)))
        ]

        for (name, offsetDir) in directions {
            let cameraOffset = offsetDir * cameraDistance
            await renderer.setCameraView(lookingAt: center, from: cameraOffset)
            try await Task.sleep(nanoseconds: 100_000_000)

            let cgImage = try await renderer.captureSnapshot()
            if let url = saveImage(cgImage, named: name) {
                savedImageURLs.append(url)
            } else {
                print("Skipping sharing for \(name) due to save error.")
            }
        }
    } catch {
        print("Snapshot failed:", error)
    }

    return savedImageURLs
}

func saveImage(_ cgImage: CGImage, named name: String) -> URL? {
    let uiImage = UIImage(cgImage: cgImage)
    let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("snapshot_\(name).png")

    guard let data = uiImage.pngData() else {
        print("Failed to convert to PNG for \(name)")
        return nil
    }

    do {
        try data.write(to: fileURL)
        print("Saved snapshot: \(fileURL.path)")
        return fileURL
    } catch {
        print("Failed to write file \(name): \(error)")
        return nil
    }
}

func computeStrokeBounds(from strokes: [Stroke]) -> (center: SIMD3<Float>, extent: SIMD3<Float>) {
    let allPoints = strokes.flatMap { $0.points }
    guard let first = allPoints.first else {
        return (.zero, .zero)
    }

    var minPoint = first
    var maxPoint = first

    for p in allPoints {
        minPoint = simd.min(minPoint, p)
        maxPoint = simd.max(maxPoint, p)
    }

    let center = (minPoint + maxPoint) / 2
    let extent = maxPoint - minPoint
    return (center, extent)
}




