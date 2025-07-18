//
//  CombinedRealityView.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/16/25.
//  Resource: https://developer.apple.com/documentation/visionos/using-a-reference-object-with-realitykit
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
    @State var objectVisualizationNames: [UUID: String] = [:]
    
    // Painting
    var paintingHandTracking = PaintingHandTracking()
    @State var canvas = PaintingCanvas()
    @State var lastIndexPose: SIMD3<Float>?
    
    // Overlay  UI
    @State private var showPrompt = false

    var body: some View {
            RealityView { content, attachments in
                // Find the URL of the reference object file.
                            let objectURL = Bundle.main.url(forResource: "Crayon Box_full_ObjectMaskOn", withExtension: ".referenceobject")!
                
                // Create an object-anchoring entity.
                            let anchorSource = AnchoringComponent.ObjectAnchoringSource(objectURL)
                            let objectAnchor = AnchorEntity(.referenceObject(from: anchorSource))
                            content.add(objectAnchor)
                
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
                            
                            //save the visualization
                            // Save the visualization
                            let model = appState.referenceObjectLoader.usdzsPerReferenceObjectID[anchor.referenceObject.id]
                            let visualization = ObjectAnchorVisualization(for: anchor, withModel: model)
                            let refObjID = anchor.referenceObject.id
                            self.objectVisualizations[id] = visualization
                            self.objectVisualizationNames[id] = refObjID.uuidString
                            root.addChild(visualization.entity)
                            
                            // Display UI
                            // Add an attachment to the object anchor.
                                    if let attachment = attachments.entity(for: "CrayonBoxLabel") {
                                        objectAnchor.addChild(attachment)
                                    }
                            let redSphere = ModelEntity(
                                mesh: .generateSphere(radius: 0.01), // 1 cm debug dot
                                materials: [SimpleMaterial(color: .red, isMetallic: false)]
                            )
                            root.addChild(redSphere)
                            
                            // check for crayon tip
                            if anchor.referenceObject.name == "PinkCrayon" {
                                let localTipOffset = SIMD4<Float>(0, 0, -0.0455, 1) // adjust sign if needed
                                let tipInWorldSpace = anchor.originFromAnchorTransform * localTipOffset
                                let crayonTipPos = SIMD3<Float>(tipInWorldSpace.x, tipInWorldSpace.y, tipInWorldSpace.z)

                                lastIndexPose = crayonTipPos
                                redSphere.position = crayonTipPos
                                print("Tip world position: \(crayonTipPos)")
                            }
                        case .updated:
                            objectVisualizations[id]?.update(with: anchor)
                            print("pink crayon updated")
                            
                        case .removed:
                            objectVisualizations[id]?.entity.removeFromParent()
                            objectVisualizations.removeValue(forKey: id)
                            print("Pink crayon no longer tracked")
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
                    
                    // Tracking the thumbs and index finger and pinch for the drawing strokes
                    // This for loop is to draw with the crayon
                    // Need to compute the crayon's position - the tip
                    for (id, objectVis) in objectVisualizations {
                        if objectVisualizationNames[id] == "PinkCrayon" {
                            let crayonPos = objectVis.entity.transform.translation
                            lastIndexPose = crayonPos
                        }
                    }


//                    for anchor in anchor {
//                        let trackedAnchor = anchor.anchor
//                        
//                        if trackedAnchor.referenceObject?.name == "PinkCrayon" {
//                            let crayonTipPos = trackedAnchor?.originFromAnchorTransform.translation
//                            lastIndexPose = crayonTipPos
//                            
//                            // No drawing when the crayon is just sitting on the table
//                            let distanceToHand = length(crayonTipPos - indexPos)
//                            if distanceToHand < holdingThreshold {
//                                lastIndexPose = crayonTipPos
//                            }
//                        }
//                    }
                    // This for loop is to draw with the hands/fingers
//                    for anchor in anchors {
//                        guard let handSkeleton = anchor.handSkeleton else { continue }
//                        
//                        let thumbPos = (anchor.originFromAnchorTransform * handSkeleton.joint(.thumbTip).anchorFromJointTransform).translation()
//                        let indexPos = (anchor.originFromAnchorTransform * handSkeleton.joint(.indexFingerTip).anchorFromJointTransform).translation()
//
//                        let pinchThreshold: Float = 0.05
//                        if length(thumbPos - indexPos) < pinchThreshold {
//                            lastIndexPose = indexPos
//                        }
//                    }
                }))
            } attachments: {
                Attachment(id: "CrayonBoxLabel") {
                    Button () {} label: {
                    Label("Tap Globe for Lunar Orbit", systemImage: "moon.circle")
                    }
//                    Text("Open the crayon box")
//                        .font(.title)
//                        .padding()
//                        .background(.thinMaterial)
//                        .cornerRadius(12)
                }
            }

        .gesture(
            TapGesture()
                .targetedToAnyEntity()
                .onEnded { value in
                    if value.entity.name == "OpenCrayonBoxButton" {
                        print("Open Crayon Box image button tapped")
                        // Take out pink crayon
                    }
                }
        )
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .targetedToAnyEntity()
                .onChanged { _ in
                    if let pos = lastIndexPose {
                        canvas.addPoint(pos)
                    }
                }
                .onEnded { _ in
                    canvas.finishStroke()
                }
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
