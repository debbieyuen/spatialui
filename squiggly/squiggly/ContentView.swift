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
    @State private var imageFile: ImageFile? = nil
    
    var body: some View {
        VStack {
            HStack {
  
                Text("Hello")
                Model3D(named: "Scene", bundle: realityKitContentBundle)
                    .padding(.bottom, 80)
            }

            }

            
            // ARKit
//            Button("Start ARKit experience") {
//                Task {
//                    await openImmersiveSpace(id: "appSpace")
//                }
//            }
//            
//            // Vision Framework
//            PhotoClassificationView()
//            if let imageFile = imageFile {
//                            Text("Classifications:")
//                            ForEach(imageFile.observations.sorted(by: { $0.value > $1.value }), id: \.key) { label, confidence in
//                                Text("\(label): \(confidence * 100, specifier: "%.2f")%")
//                            }
//                        } else {
//                            Text("No classification yet")
//                        }
//
//            Button("Run Classification") {
//                Task {
//                    if let url = Bundle.main.url(forResource: "your_image", withExtension: "jpg") {
//                        imageFile = try? await classifyImage(url: url)
//                    }
//                }
//            }
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
