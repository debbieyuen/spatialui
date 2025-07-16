//
//  squigglyApp.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/2/25.
//  Resources: https://developer.apple.com/documentation/visionos/creating-your-first-visionos-app
//

import SwiftUI

@main
struct squigglyApp: App {
    // AppState for Object Detection Views
    @State private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            // Change opacity
            ContentView(
                appState: appState,
                immersiveSpaceIdentifier: UIIdentifier.immersiveSpace
            )
//                .background(.black.opacity(0.8))
        }
        ImmersiveSpace(id: UIIdentifier.paintingScene) {
            PaintingView()
        }
        
        // Immersive Space for object tracking
                       ImmersiveSpace(id: UIIdentifier.immersiveSpace) {
            ObjectTrackingRealityView(appState: appState)
        }
    }
}
