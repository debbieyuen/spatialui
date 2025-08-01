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
    @State private var isPinkCrayonDetected = false
    
    // Painting
    var paintingHandTracking = PaintingHandTracking()
    @ObservedObject var canvas: PaintingCanvas
    @State var lastIndexPose: SIMD3<Float>?
    
    // Hold Crayon and factor out random pinches
    @State private var holdFrameCount = 0
    let holdFrameTreshold = 7

    // Overlay  UI
    @State private var showPrompt = false
    
    // Photo Classification
    @State private var drawingClassifier = DrawingClassifier()
    @State private var predictedDigit: String?
    
    // Picking Colors
    @State private var selectedColor: Color = .pink
    @State private var userSelectedColor: Color = .pink
    @State private var currentCrayonName: String? = nil
    
    // Wrist Anchoring
    @State private var leftWristAnchor = AnchorEntity(.hand(.left, location: .wrist))
    
    var body: some View {
        RealityView { content, attachments in
            content.add(root)
            
            // Add painting canvas
            root.addChild(canvas.root)
            
             // Add left wrist palette anchor
            content.add(leftWristAnchor)
            
            if let wristUI = attachments.entity(for: "WristPalette") {
                wristUI.components[BillboardComponent.self] = .init()
                wristUI.position = [0, 0, 0.08]  // float slightly above wrist
                leftWristAnchor.addChild(wristUI)
            }
            
            // Object Tracking Task
            Task {
                let objectTracking = await appState.startTracking()
                guard let objectTracking else { return }
                
                for await anchorUpdate in objectTracking.anchorUpdates {
                    let anchor = anchorUpdate.anchor
                    let id = anchor.id
                    let objectName = anchor.referenceObject.name
                    
                    switch anchorUpdate.event {
                    case .added:
                        // Skip detection if a crayon is already active
                        if let active = currentCrayonName,
                               ["PinkCrayon", "RedCrayon", "GreenCrayon"].contains(objectName),
                               objectName != active {
                                print("\(objectName) detected but \(active) is still active — ignoring.")
                                break
                            }
                        
                        let model = appState.referenceObjectLoader.usdzsPerReferenceObjectID[anchor.referenceObject.id]
                        let visualization = ObjectAnchorVisualization(for: anchor, withModel: model)
                        self.objectVisualizations[id] = visualization
                        root.addChild(visualization.entity)
                        // Attach specific UI based on the object
                        switch objectName {
                        case "Crayonbox 3_raw_ObjectMaskOn":
                            print("Crayon Box detected")
                            if let attachment = attachments.entity(for: "CrayonBoxLabel") {
                                attachment.position = [0, 0.15, 0]
                                visualization.entity.addChild(attachment)
                            }

                        case "PinkCrayon", "RedCrayon", "GreenCrayon":
                       
                            let color: Color
                            let labelID = "PinkCrayonLabel"  // Reuse the same label attachment for all crayons
                            let attachment = attachments.entity(for: labelID)

                            switch objectName {
                            case "PinkCrayon":
                                color = Color(red: 1.0, green: 0.6196, blue: 0.9765)
                            case "RedCrayon":
                                color = .red
                            case "GreenCrayon":
                                color = .green
                            default:
                                color = .gray // fallback
                            }

                            currentCrayonColor(
                                name: objectName,
                                color: color,
                                labelID: labelID,
                                attachment: attachment,
                                visualization: visualization
                            )

                        default:
                            break
                        }
                    case .updated:
                        objectVisualizations[id]?.update(with: anchor)
                        
                    case .removed:
                        objectVisualizations[id]?.entity.removeFromParent()
                        objectVisualizations.removeValue(forKey: id)
                        // Reset crayon name
                        if anchor.referenceObject.name == currentCrayonName {
                                print("Crayon \(currentCrayonName!) removed — resetting lock")
                                currentCrayonName = nil
                                isPinkCrayonDetected = false
                            }
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
        } attachments: {
            Attachment(id: "CrayonBoxLabel") {
                // Overlay button and optional result
                        VStack {
                            Text("Open and Draw!")
                            HStack {
                                Button("Classify") {
                                    if let snapshot = canvas.snapshotImage() {
                                        if let digit = drawingClassifier.classify(drawingImage: snapshot) {
                                            predictedDigit = digit
                                            print("Predicted digit: \(digit)")
                                        } else {
                                            print("Could not classify drawing")
                                        }
                                    } else {
                                        print("Could not take snapshot of canvas")
                                    }
                                }
                            }
                            if let predictedDigit {
                                Text("Predicted digit: \(predictedDigit)")
                                    .font(.title)
                                    .padding()
                                    .background(Color.yellow.opacity(0.8))
                                    .cornerRadius(10)
                            }
                        }
            }
            Attachment(id: "PinkCrayonLabel") {
                Button () {} label: {
                    Label("Found the Pink Crayon!", systemImage: "moon.circle")
                }
            }
            Attachment(id: "WristPalette") {
                LeftUIPaletteView(canvas: canvas)
            }

        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .targetedToAnyEntity()
                .onChanged { _ in
                    if let pos = lastIndexPose {
                        if isPinkCrayonDetected {
                            holdFrameCount += 1
                            print("First Hold frame count: \(holdFrameCount)")
                            if holdFrameCount >= holdFrameTreshold {
                                canvas.addPoint(pos)
                                print("Hold frame count: \(holdFrameCount)")
                            }
                        }
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
    func currentCrayonColor(name: String, color: Color, labelID: String, attachment: Entity?, visualization: ObjectAnchorVisualization) {
           guard currentCrayonName == nil else { return }

           print("\(name) detected — drawing unlocked")
           canvas.selectedColor = color
           isPinkCrayonDetected = true
        currentCrayonName = name

           if let attachment = attachment {
               attachment.name = labelID
               visualization.entity.addChild(attachment)
           }

           DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
               if currentCrayonName == name {
                   print("\(name) timeout expired — unlocking")
                   currentCrayonName = nil
                   isPinkCrayonDetected = false
               }
           }
       }
    
}
