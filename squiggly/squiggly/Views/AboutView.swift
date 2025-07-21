//
//  AboutView.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/19/25.
//  Resources: https://developer.apple.com/documentation/visionos/adding-a-depth-effect-to-text-in-visionos
//  Resources: 
//

import SwiftUI
import RealityKit
import RealityKitContent
import ARKit

struct AboutView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack(spacing: 0) {
                // Left side
                VStack(alignment: .leading) {
                    Text("Welcome to Vancouver")
                        .font(.largeTitle)
                        .padding(.bottom, 15)
                        .accessibilitySortPriority(4)
                    
                    Text("Thank you for joining our session today at SIGGRAPH Vancouver! We are excited to have you join us. Here, you will find our demo application that you may experiment with as you wish. Try modifying the code and creating your own user interfaces. Please do not hesitate to raise your hands if you have any questions.").accessibilitySortPriority(3)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(40)

                // Right Side
                VStack {
                    RealityView { content in
                        // 3D text setup
                        if let textMesh = try? await MeshResource.generateText(
                            "squiggly",
                            extrusionDepth: 0.02,
                            font: UIFont(name: "SnellRoundhand-Bold", size: 0.2) ?? .systemFont(ofSize: 0.2),
                            containerFrame: .zero,
                            alignment: .center,
                            lineBreakMode: .byWordWrapping
                        ) {
                            let textMaterial = SimpleMaterial(color: .purple, isMetallic: false)
                            let textEntity = ModelEntity(mesh: textMesh, materials: [textMaterial])
                            textEntity.position = [-0.07, -0.1, 0.0]
                            textEntity.scale = [0.2, 0.5, 0.5]
                            content.add(textEntity)
                        }
                        // 3D Model Pixel
                        if let entity = try? await Entity(named: "PinkPixel22", in: realityKitContentBundle) {
                            entity.scale = SIMD3<Float>(repeating: 0.65)
                            entity.position.y += 0.1   // move up 0.2 meters
                            entity.position.x -= 0.03   // move left 0.1 meters (negative X is left)
                            entity.position.z -= 0.1
                            content.add(entity)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding(50)
            }
        }
    }
}

//@ViewBuilder
//func topButton(title: String, url: String) -> some View {
//    Button(action: {
//        if let link = URL(string: url) {
//            UIApplication.shared.open(link)
//        }
//    }) {
//        HStack {
//            Text(title)
//            //            Image(systemName: "arrow.right")
//        }
//    }
//}

#Preview {
    AboutView()
}
