//
//  DrawView.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/20/25.
//

import SwiftUI
import RealityKit
import RealityKitContent
import ARKit

struct DrawView: View {
    @State private var selectedColor: Color = .pink
    var body: some View {
        RealityView { content in
            // 3D text setup
            if let textMesh = try? await MeshResource.generateText(
                "try uploading 3d models",
                extrusionDepth: 0.02,
                font: UIFont(name: "SnellRoundhand-Bold", size: 0.2) ?? .systemFont(ofSize: 0.2),
                containerFrame: .zero,
                alignment: .center,
                lineBreakMode: .byWordWrapping
            ) {
                let textMaterial = SimpleMaterial(color: .purple, isMetallic: false)
                let textEntity = ModelEntity(mesh: textMesh, materials: [textMaterial])
//                textEntity.position = [-0.07, -0.1, 0.0]
                textEntity.scale = [0.2, 0.5, 0.5]
                content.add(textEntity)
            }
            // 3D Model Pixel
            if let entity = try? await Entity(named: "PinkPixel22", in: realityKitContentBundle) {
                entity.scale = SIMD3<Float>(repeating: 0.65)
//                entity.position.y += 0.1   // move up 0.2 meters
//                entity.position.x -= 0.03   // move left 0.1 meters (negative X is left)
                entity.position.z -= 0.1
                content.add(entity)
                rotatingIntroAnimation(entity: entity)
            }
        }
    }
}

#Preview {
    DrawView()
}
