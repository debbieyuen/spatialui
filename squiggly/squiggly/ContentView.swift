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
    
    var body: some View {
        VStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 80)

            Text("Hello, world!")
            
            Button("Start ARKit experience") {
                Task {
                    await openImmersiveSpace(id: "appSpace")
                }
            }
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
