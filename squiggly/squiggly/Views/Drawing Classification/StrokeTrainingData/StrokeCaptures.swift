//
//  StrokeCaptures.swift
//  squiggly
//
//  Created by Debbie Yuen on 8/1/25.
//  Resource: https://youtu.be/XEkNKPwcmz4?si=vDdO92PXB7WoIrW1
//

import RealityKit
import Metal
import CoreGraphics

@MainActor
final class OffscreenRenderModel {
    private let renderer: RealityRenderer
    private let cameraEntity: PerspectiveCamera
    private let colorTexture: MTLTexture

    init(sceneRoot: Entity, size: CGSize = CGSize(width: 512, height: 512)) throws {
        // Initialize renderer
        renderer = try RealityRenderer()

        // Attach root entity
        renderer.entities.append(sceneRoot)

        // Set up a camera
        let camera = PerspectiveCamera()
        camera.camera.fieldOfViewInDegrees = 60
        renderer.activeCamera = camera
        cameraEntity = camera
        renderer.entities.append(camera)

        // Prepare output texture
        let device = MTLCreateSystemDefaultDevice()!
        let desc = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: .rgba8Unorm,
            width: Int(size.width),
            height: Int(size.height),
            mipmapped: false
        )
        desc.usage = [.renderTarget, .shaderRead]
        colorTexture = device.makeTexture(descriptor: desc)!
    }
    func setCameraTransform(_ transform: Transform) {
        cameraEntity.transform = transform
    }

    func captureSnapshot(deltaTime: TimeInterval = 0.0) throws -> CGImage {
        let outputDesc = RealityRenderer.CameraOutput.Descriptor.singleProjection(
            colorTexture: colorTexture
        )
        let cameraOutput = try RealityRenderer.CameraOutput(outputDesc)

        try renderer.updateAndRender(
            deltaTime: deltaTime,
            cameraOutput: cameraOutput,
            onComplete: { _ in }
        )

        guard let texture = cameraOutput.colorTextures.first else {
            fatalError("No color texture from camera output")
        }
        return texture.toCGImage()!
    }
    
    func setCameraView(lookingAt target: SIMD3<Float>, from offset: SIMD3<Float>) {
        let cameraPosition = target + offset
        cameraEntity.look(at: target, from: cameraPosition, relativeTo: nil)
    }

    
}



