//
//  ObjectAttachmentHelper.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/21/25.
//

import RealityKit

extension SIMD4 where Scalar == Float {
    var xyz: SIMD3<Float> {
        SIMD3(x, y, z)
    }
}

func objectAttachmentHelper(to attachment: Entity, relativeTo root: Entity) {
    attachment.components.set(ClosureComponent { deltaTime in
        guard let cameraEntity = root.scene?.findEntity(named: "ARCamera") else { return }

        // ✅ FIXED: use transformMatrix(relativeTo: nil)
        let attachmentWorldPosition = attachment.transformMatrix(relativeTo: nil).columns.3.xyz
        let cameraWorldPosition = cameraEntity.transformMatrix(relativeTo: nil).columns.3.xyz

        // Vector from attachment to camera
        var toCamera = cameraWorldPosition - attachmentWorldPosition
        toCamera = normalize(toCamera)

        // Get camera 'up' and 'right' vectors
        let cameraUp = cameraEntity.transformMatrix(relativeTo: nil).columns.1.xyz
        let cameraRight = cameraEntity.transformMatrix(relativeTo: nil).columns.0.xyz

        // Build world-facing rotation
        let forward = -toCamera
        let right = normalize(cross(cameraUp, forward))
        let up = cross(forward, right)

        let rotationMatrix = float3x3(columns: (right, up, forward))
        let worldRotation = simd_quatf(rotationMatrix)

        // Cancel parent rotation
        let parentRotation = attachment.parent?.transform.rotation ?? simd_quatf()
        let correctedLocalRotation = simd_inverse(parentRotation) * worldRotation

        attachment.transform.rotation = correctedLocalRotation
    })
}





