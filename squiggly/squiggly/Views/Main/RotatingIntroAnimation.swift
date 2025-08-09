//
//  PixelAnimation.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/21/25.
//

import RealityKit

func rotatingIntroAnimation(entity: Entity) {
    entity.components.set(ClosureComponent { deltaTime in
        let rotationSpeed: Float = 0.5
        let deltaTimeFloat = Float(deltaTime)
        let deltaRotation = simd_quatf(angle: rotationSpeed * deltaTimeFloat, axis: [0, 1, 0])
        entity.transform.rotation *= deltaRotation
    })
}
