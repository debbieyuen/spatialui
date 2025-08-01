//
//  StrokeCaptures.swift
//  squiggly
//
//  Created by Debbie Yuen on 8/1/25.
//

import Foundation
import RealityKit
import UIKit

class StrokeCaptures {
    // RealityRender helps us take snapshots
    let renderer: RealityRenderer
    // The immersive scene/space we want to take pictures of
    let rootEntity: Entity
    // The image size
    let captureSize: CGSize
    
    init(renderer: RealityRenderer, rootEntity: Entity, captureSize: CGSize = CGSize(width: 512, height: 512)) {
        self.renderer = renderer
        self.rootEntity = rootEntity
        self.captureSize = captureSize
    }
    
    // Take snapshots from certain angles, perspectives, and directions
    private let directions: [(name: String, transform: Transform)] = [
        ("front", Transform(pitch: 0, yaw: .pi, roll: 0)),
        ("back", Transform(pitch: 0, yaw: 0, roll: 0)),
        ("left", Transform(pitch: 0, yaw: -.pi/2, roll: 0)),
        ("right", Transform(pitch: 0, yaw: .pi/2, roll: 0)),
        ("top", Transform(pitch: -.pi/2, yaw: 0, roll: 0)),
        ("bottom", Transform(pitch: .pi/2, yaw: 0, roll: 0)),
        ("oblique1", Transform(pitch: -.pi/4, yaw: .pi/4, roll: 0)),
        ("oblique2", Transform(pitch: .pi/4, yaw: -.pi/4, roll: 0))
    ]
    
}
