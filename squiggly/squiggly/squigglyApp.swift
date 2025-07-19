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
//                CrayonObjectDetectionView(appState: appState, immersiveSpaceIdentifier: UIIdentifier.immersiveSpace)
                ContentView(
                    appState: appState,
                    immersiveSpaceIdentifier: UIIdentifier.immersiveSpace
                )
            }
//            ImmersiveSpace(id: UIIdentifier.paintingScene) {
//                PaintingView()
//            }
//            
            ImmersiveSpace(id: UIIdentifier.immersiveSpace) {
                CombinedRealityView(appState: appState)
            }
    }
}

