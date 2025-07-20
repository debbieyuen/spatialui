//
//  ContentView.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/2/25.
//  ARKit: https://developer.apple.com/documentation/visionOS/setting-up-access-to-arkit-data
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    // Call openImmersive Space to create a space to run ARKit session
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    // Grab image file for the Vision Framework
//    @State private var imageFile: ImageFile? = nil
    // Appstate() for object detection
//    @State private var appState = AppState()
//    private let immersiveSpaceIdentifier = UIIdentifier.immersiveSpace
    @Bindable var appState: AppState
    let immersiveSpaceIdentifier: String

    var body: some View {
        TabView {
            AboutView()
                .tabItem {
                    Label("Welcome", systemImage: "info.circle")
                }
            PhotoClassificationView()
                .tabItem {
                    Label("Photos", systemImage: "photo.on.rectangle")
                }
            
//            Text("Favorites")
            CrayonObjectDetectionView(appState: appState, immersiveSpaceIdentifier: immersiveSpaceIdentifier)
                .tabItem {
                    Label("Objects", systemImage: "arkit")
                }
//            Text("Draw")
            DrawView()
                .tabItem {
                    Label("Draw", systemImage: "paintpalette")
                }
        }
        .task {
            if appState.allRequiredProvidersAreSupported {
                await appState.referenceObjectLoader.loadBuiltInReferenceObjects()
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView(appState: AppState(), immersiveSpaceIdentifier: UIIdentifier.immersiveSpace)
}

