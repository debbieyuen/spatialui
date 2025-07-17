//
//  CombinedRealityView.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/16/25.
//

import SwiftUI
import RealityKit
import ARKit

@MainActor
struct CombinedRealityView: View {
    var appState: AppState

    // Root entity
    var root = Entity()
    
    // Object Tracking
    @State private var objectVisualizations: [UUID: ObjectAnchorVisualization] = [:]
    
    // Painting
    var paintingHandTracking = PaintingHandTracking()
    @State var canvas = PaintingCanvas()
    @State var lastIndexPose: SIMD3<Float>?
    
    // Overlay  UI
    @State private var showPrompt = false

    var body: some View {
            RealityView { content in
                content.add(root)
                
                // Add painting canvas
                root.addChild(canvas.root)
                
                // Object Tracking Task
                Task {
                    let objectTracking = await appState.startTracking()
                    guard let objectTracking else { return }

                    for await anchorUpdate in objectTracking.anchorUpdates {
                        let anchor = anchorUpdate.anchor
                        let id = anchor.id
                        
                        switch anchorUpdate.event {
                        case .added:
                            print("Anchor transform for \(anchor.referenceObject.name):")
                            print(anchor.originFromAnchorTransform)
                            
                            let model = appState.referenceObjectLoader.usdzsPerReferenceObjectID[anchor.referenceObject.id]
                            let visualization = ObjectAnchorVisualization(for: anchor, withModel: model)
                            self.objectVisualizations[id] = visualization
                            root.addChild(visualization.entity)
                            
                            // Display overlay UI
                            if anchor.referenceObject.name == "Crayon Box_full_ObjectMaskOn" && !showPrompt {
                                showPrompt = true
                            }
                            
                            let textMesh = MeshResource.generateText(
                                "Please open the box",
                                extrusionDepth: 0.01,
                                font: .systemFont(ofSize: 0.1),
                                containerFrame: .zero,
                                alignment: .center,
                                lineBreakMode: .byWordWrapping
                            )

                            var material = SimpleMaterial()
                            material.color = .init(tint: .white, texture: nil)

                            let textEntity = ModelEntity(mesh: textMesh, materials: [material])
                            textEntity.transform.translation = [0, 0.1, 0]  // slightly above anchor

                            visualization.entity.addChild(textEntity)
                            
                        case .updated:
                            objectVisualizations[id]?.update(with: anchor)
                            
                        case .removed:
                            objectVisualizations[id]?.entity.removeFromParent()
                            objectVisualizations.removeValue(forKey: id)
                        }
                    }
                }

                // Painting Hand Tracking Closure
                root.components.set(ClosureComponent(closure: { deltaTime in
                    var anchors = [HandAnchor]()

                    if let latestLeftHand = paintingHandTracking.latestLeftHand {
                        anchors.append(latestLeftHand)
                    }
                    if let latestRightHand = paintingHandTracking.latestRightHand {
                        anchors.append(latestRightHand)
                    }

                    for anchor in anchors {
                        guard let handSkeleton = anchor.handSkeleton else { continue }

                        let thumbPos = (anchor.originFromAnchorTransform * handSkeleton.joint(.thumbTip).anchorFromJointTransform).translation()
                        let indexPos = (anchor.originFromAnchorTransform * handSkeleton.joint(.indexFingerTip).anchorFromJointTransform).translation()

                        let pinchThreshold: Float = 0.05
                        if length(thumbPos - indexPos) < pinchThreshold {
                            lastIndexPose = indexPos
                        }
                    }
                }))
            }
        .gesture(
            DragGesture(minimumDistance: 0)
                .targetedToAnyEntity()
                .onChanged({ _ in
                    if let pos = lastIndexPose {
                        canvas.addPoint(pos)
                    }
                })
                .onEnded({ _ in
                    canvas.finishStroke()
                })
        )
        .onAppear {
            print("Entering immersive space.")
            appState.isImmersiveSpaceOpened = true
            Task { await paintingHandTracking.startTracking() }
        }
        .onDisappear {
            print("Leaving immersive space.")
            
            for (_, visualization) in objectVisualizations {
                root.removeChild(visualization.entity)
            }
            objectVisualizations.removeAll()
            
            appState.didLeaveImmersiveSpace()
        }
    }
}
