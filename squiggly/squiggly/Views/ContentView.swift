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
        // Header
        HStack {
            // Left Header
            HStack {
                Image("yourLogoAssetName")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                Text("Squiggly App")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            Spacer()
            
            // Right Header
            HStack {
                topButton(title: "Course Website", url: "https://theapplevisionpro.vercel.app")
                topButton(title: "GitHub Repo", url: "https://github.com/debbieyuen/spatialui")
            }
        }
        .padding(20)
        TabView {
            PhotoClassificationView()
                .tabItem {
                    Label("Photos", systemImage: "photo.on.rectangle")
                }
            
//            Text("Favorites")
            CrayonObjectDetectionView(appState: appState, immersiveSpaceIdentifier: immersiveSpaceIdentifier)
                .tabItem {
                    Label("Objects", systemImage: "arkit")
                }
            Text("Draw")
                .tabItem {
                    Label("Draw", systemImage: "pencil.tip")
                }
            Text("Erase")
                .tabItem {
                    Label("Erase", systemImage: "eraser")
                }
            Text("Color Palette")
                .tabItem {
                    Label("Color Palette", systemImage: "paintpalette")
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

