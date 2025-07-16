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
        NavigationStack {
            ZStack(alignment: .topLeading) {
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
    //                    topButton(title: "Help", url: "https://example.com/c")
                    }
                }
                .padding(20)

                // Main Body Section
                HStack(spacing: 0) {
                    // Left side
                    VStack(alignment: .leading) {
                        Text("Welcome to Vancouver")
                            .font(.largeTitle)
                            .padding(.bottom, 15)
                            .accessibilitySortPriority(4)

                        Text("Thank you for joining our session today at SIGGRAPH Vancouver! We are excited to have you join us. Here, you will find our demo application that you may experiment with as you wish. Try modifying the code and creating your own user interfaces. Please do not hesitate to raise your hands if you have any questions.").accessibilitySortPriority(3)
                        
                        NavigationLink(destination:
                                        MachineLearningModelsView(appState: appState, immersiveSpaceIdentifier: immersiveSpaceIdentifier)) {
                            Text("Start")
                        }
                        .padding(.top)
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding(40)

                    // Right Side
                    VStack {
//                        RealityView { content in
//                            if let entity = try? await Entity(named: "PinkPixel22", in: realityKitContentBundle) {
//                                entity.scale = SIMD3<Float>(repeating: 0.65)
//                                entity.position.y += 0.1   // move up 0.2 meters
//                                entity.position.x -= 0.03   // move left 0.1 meters (negative X is left)
//                                entity.position.z -= 0.1
//                                content.add(entity)
//                            }
//                        }

                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(50)
                }
            }
        }
        
        .task {
            if appState.allRequiredProvidersAreSupported {
                await appState.referenceObjectLoader.loadBuiltInReferenceObjects()
            }
        }
    }
}

@ViewBuilder
func topButton(title: String, url: String) -> some View {
    Button(action: {
        if let link = URL(string: url) {
            UIApplication.shared.open(link)
        }
    }) {
        HStack {
            Text(title)
//            Image(systemName: "arrow.right")
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView(appState: AppState(), immersiveSpaceIdentifier: UIIdentifier.immersiveSpace)
}

