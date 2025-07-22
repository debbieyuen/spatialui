////
////  LeftPalette.swift
////  squiggly
////
////  Created by Debbie Yuen on 7/22/25.
////  Resource: https://github.com/radicalappdev/Step-Into-Labs/blob/main/Step%20Into%20Labs/Labs/Lab007.swift
////  Resource: https://stepinto.vision/labs/lab-007-anchor-an-attachment-to-a-hand/
////  Resource: https://medium.com/@siddharth_70859/creating-a-hand-menu-in-vision-pro-with-swiftui-and-realitykit-d49f25428384
////
//
//import SwiftUI
//import RealityKit
//
//struct LeftUIPaletteView: View {
//    @State var handTrackedEntity: Entity = {
//        // Wrist Anchor
//        let handAnchor = AnchorEntity(.hand(.left, location: .wrist))
//        return handAnchor
//    }()
//
//    @State var scaler: Float = 1.0
//    @State var target: Entity?
//
//    var body: some View {
//        RealityView { content, attachments in
//            // Add wrist-anchored entity to scene graph
//            content.add(handTrackedEntity)
//
//            // Load attachment content
//            if let attachmentEntity = attachments.entity(for: "AttachmentContent") {
//                // Make sure it always faces the user
//                attachmentEntity.components[BillboardComponent.self] = .init()
//
//                // Slightly offset outward from wrist (like a watch screen)
//                attachmentEntity.position = SIMD3(x: 0, y: 0, z: 0.05)
//
//                handTrackedEntity.addChild(attachmentEntity)
//            }
//
//        } update: { content, attachments in
//
//        } attachments: {
//
//            // Create a compact, wrist-friendly UI
//            Attachment(id: "AttachmentContent") {
//                HStack(spacing: 8) {
//                }
//                .padding(6)
//                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
//                .padding(2)  // add a bit of outer padding
//            }
//
//        }
//    }
//}
//
//#Preview {
//    LeftUIPaletteView()
//}
