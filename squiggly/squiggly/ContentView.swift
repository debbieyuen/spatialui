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
        ZStack(alignment: .topLeading) {
            // Top-left logo and App Name
            HStack(spacing: 8) {
                Image("")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle()) // optional

                Text("Squiggly App")
                    .font(.headline)
                    .foregroundColor(.white)
            }.padding(16)
            
            // Main Body Section
            HStack(spacing: 0) {
                // Left side
                VStack(alignment: .leading) {
                    Text("Welcome to SIGGRAPH 2025 in Vancouver!")
                        .font(.system(size: 50, weight: .bold))
                        .padding(.bottom, 15)
                        .accessibilitySortPriority(4)

                    Text("Hello").accessibilitySortPriority(3)
                    
                    Button("Start") {
                        
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(40)

                // Right Side
                VStack {
                        Model3D(named: "Scene", bundle: realityKitContentBundle)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding(40)
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}













//struct ContentView: View {
//    // Call openImmersive Space to create a space to run ARKit session
//    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
//    // Grab image file for the Vision Framework
//    @State private var imageFile: ImageFile? = nil
//    
//    var body: some View {
//        
//        VStack {
//            GeometryReader { proxy in
//                let textWidth = min(max(proxy.size.width * 0.4, true ? 500 : 300), 500)
//                let imageWidth = min(max(proxy.size.width - textWidth, 300), 700)
//                ZStack {
//                    HStack(spacing: 60) {
//                        VStack(alignment: .leading, spacing: 0) {
//                            Text("Welcome to SIGGRAPH Vancouver!")
//                                .font(.system(size: 50, weight: .bold))
//                                .padding(.bottom, 15)
//                                .accessibilitySortPriority(4)
//                            
//                            Text("Hello")
//                                .padding(.bottom, 24)
//                                .accessibilitySortPriority(3)
//                        }
//                        .frame(width: textWidth, alignment: .leading)
//                        //
//                        //                        module.detailView
//                        //                            .frame(width: imageWidth, alignment: .center)
//                    }
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//            }
//            .padding([.leading, .trailing], 70)
//            .padding(.bottom, 24)
//            .background {
//                //            Model3D(named: "Scene", bundle: realityKitContentBundle)
//                //                .padding(.bottom, 80)
//                //
//                //            Text("Hello, world!")
//                //
//                //            // ARKit
//                //            Button("Start ARKit experience") {
//                //                Task {
//                //                    await openImmersiveSpace(id: "appSpace")
//                //                }
//                //            }
//                //
//                //            // Vision Framework
//                //            PhotoClassificationView()
//                //            if let imageFile = imageFile {
//                //                            Text("Classifications:")
//                //                            ForEach(imageFile.observations.sorted(by: { $0.value > $1.value }), id: \.key) { label, confidence in
//                //                                Text("\(label): \(confidence * 100, specifier: "%.2f")%")
//                //                            }
//                //                        } else {
//                //                            Text("No classification yet")
//                //                        }
//                //
//                //            Button("Run Classification") {
//                //                Task {
//                //                    if let url = Bundle.main.url(forResource: "your_image", withExtension: "jpg") {
//                //                        imageFile = try? await classifyImage(url: url)
//                //                    }
//                //                }
//                //            }
//            }
//            .padding()
//        }
//    }}

