//
//  ContentView.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/2/25.
//  ARKit: https://developer.apple.com/documentation/visionOS/setting-up-access-to-arkit-data
//  Resources: https://www.createwithswift.com/creating-advanced-hover-effects-in-visionos/
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
    @State private var selectedColor: Color = .pink
    var canvas: PaintingCanvas


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
            CrayonObjectDetectionView(appState: appState, immersiveSpaceIdentifier: immersiveSpaceIdentifier, selectedColor: $selectedColor, canvas: canvas)
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
        .ornament(attachmentAnchor: .scene(.top)) {
            HStack(spacing: 64) {
                // GitHub button
                Button {
                    if let url = URL(string: "https://github.com/debbieyuen/spatialui") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left.slash.chevron.right")
                        Text("GitHub")
                            .font(.caption2)
                    }
                }.accessibilityLabel("Close")
                
                // Website button
                Button {
                    if let url = URL(string: "https://theapplevisionpro.vercel.app") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "safari")
                        Text("Website")
                            .font(.caption2)
                    }
                }
            }
            .padding(.horizontal)
            .padding(12)
            .glassBackgroundEffect()
            .buttonStyle(.plain)
        }

    }
}

#Preview(windowStyle: .automatic) {
    ContentView(appState: AppState(), immersiveSpaceIdentifier: UIIdentifier.immersiveSpace, canvas: PaintingCanvas())
}


