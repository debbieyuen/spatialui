////
////  ReferenceObjectLoader.swift
////  squiggly
////
////  Created by Debbie Yuen on 7/13/25.
////  Resources: https://developer.apple.com/documentation/visionos/exploring_object_tracking_with_arkit
////  https://www.youtube.com/watch?v=NaB_6hLzYN0&t=151s
////
//
//import RealityKit
//import ARKit
//import SwiftUI
//
//@MainActor
//struct ObjectTrackingRealityView: View {
//    // Object Tracking
//    var appState: AppState
//    var root = Entity()
//    @State private var objectVisualizations: [UUID: ObjectAnchorVisualization] = [:]
//    
//    // Painting View
//    var paintingHandTracking = PaintingHandTracking()
//    @State var canvas = PaintingCanvas()
//    @State var lastIndexPose: SIMD3<Float>?
//
//    var body: some View {
//        RealityView { content in
//            content.add(root)
//
//            Task {
//                let objectTracking = await appState.startTracking()
//                guard let objectTracking else {
//                    return
//                }
//                
//                // Wait for object anchor updates and maintain a dictionary of visualizations
//                // that are attached to those anchors.
//                for await anchorUpdate in objectTracking.anchorUpdates {
//                    let anchor = anchorUpdate.anchor
//                    let id = anchor.id
//                    
//                    switch anchorUpdate.event {
//                    case .added:
//                        // Debug: print the world transform
//                        print("Anchor transform for \(anchor.referenceObject.name):")
//                        print(anchor.originFromAnchorTransform)
//                        
//                        // Create a new visualization for the reference object that ARKit just detected.
//                        // The app displays the USDZ file that the reference object was trained on as
//                        // a wireframe on top of the real-world object, if the .referenceobject file contains
//                        // that USDZ file. If the original USDZ isn't available, the app displays a bounding box instead.
//                        let model = appState.referenceObjectLoader.usdzsPerReferenceObjectID[anchor.referenceObject.id]
//                        let visualization = ObjectAnchorVisualization(for: anchor, withModel: model)
//                        self.objectVisualizations[id] = visualization
//                        root.addChild(visualization.entity)
//                    case .updated:
//                        objectVisualizations[id]?.update(with: anchor)
//                    case .removed:
//                        objectVisualizations[id]?.entity.removeFromParent()
//                        objectVisualizations.removeValue(forKey: id)
//                    }
//                }
//            }
//        }
//        .onAppear() {
//            print("Entering immersive space.")
//            appState.isImmersiveSpaceOpened = true
//        }
//        .onDisappear() {
//            print("Leaving immersive space.")
//            
//            for (_, visualization) in objectVisualizations {
//                root.removeChild(visualization.entity)
//            }
//            objectVisualizations.removeAll()
//            
//            appState.didLeaveImmersiveSpace()
//        }
//    }
//}
//
////import RealityKit
////import ARKit
////import SwiftUI
////
////@MainActor
////struct ObjectTrackingRealityView: View {
////    var appState: AppState
////    
////    var root = Entity()
////    
////    @State private var objectVisualizations: [UUID: ObjectAnchorVisualization] = [:]
////
////    var body: some View {
////        RealityView { content in
////            content.add(root)
////
////            Task {
////                let objectTracking = await appState.startTracking()
////                guard let objectTracking else {
////                    return
////                }
////                
////                // Wait for object anchor updates and maintain a dictionary of visualizations
////                // that are attached to those anchors.
////                for await anchorUpdate in objectTracking.anchorUpdates {
////                    let anchor = anchorUpdate.anchor
////                    let id = anchor.id
////                    
////                    switch anchorUpdate.event {
////                    case .added:
////                        // Create a new visualization for the reference object that ARKit just detected.
////                        // The app displays the USDZ file that the reference object was trained on as
////                        // a wireframe on top of the real-world object, if the .referenceobject file contains
////                        // that USDZ file. If the original USDZ isn't available, the app displays a bounding box instead.
////                        let model = appState.referenceObjectLoader.usdzsPerReferenceObjectID[anchor.referenceObject.id]
////                        let visualization = ObjectAnchorVisualization(for: anchor, withModel: model)
////                        self.objectVisualizations[id] = visualization
////                        root.addChild(visualization.entity)
////                    case .updated:
////                        objectVisualizations[id]?.update(with: anchor)
////                    case .removed:
////                        objectVisualizations[id]?.entity.removeFromParent()
////                        objectVisualizations.removeValue(forKey: id)
////                    }
////                }
////            }
////        }
////        .onAppear() {
////            print("Entering immersive space.")
////            appState.isImmersiveSpaceOpened = true
////        }
////        .onDisappear() {
////            print("Leaving immersive space.")
////            
////            for (_, visualization) in objectVisualizations {
////                root.removeChild(visualization.entity)
////            }
////            objectVisualizations.removeAll()
////            
////            appState.didLeaveImmersiveSpace()
////        }
////    }
////}
