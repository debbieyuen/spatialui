//
//  MachineLearningModelsView.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/11/25.
//

import SwiftUI
import RealityKit
import RealityKitContent
//import SplineRuntime

struct MachineLearningModelsView: View {
    @State private var selectedModelName: String = "EarthModel"
    var appState: AppState
    var immersiveSpaceIdentifier: String
    
    var body: some View {
        NavigationStack {
//            let url = URL(string: "sceneFileURL")!

            // fetching from local
            // let url = Bundle.main.url(forResource: "scene", withExtension: "splineswift")!

//            SplineView(sceneFileURL: url).ignoresSafeArea(.all)
//            
//            // Top 2/3: 3D Model Preview
//            Model3D(named: "Scene", bundle: realityKitContentBundle)
//            RealityView { content in
//                if let entity = try? await Entity(named: selectedModelName) {
//                    content.add(entity)
//                }
//            }
//            .frame(maxHeight: .infinity)
            
            List {
                NavigationLink(destination: PhotoClassificationView()) {
                    VStack(alignment: .leading) {
                        Text("Photo Classification")
                            .font(.headline)
                        Text("Classify images from your photo gallery with PhotoUI and the Vision Framework.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                NavigationLink(destination: CrayonObjectDetectionView(appState: appState, immersiveSpaceIdentifier: immersiveSpaceIdentifier)) {
                    VStack(alignment: .leading) {
                        Text("Object Detection with Vision and FastViT")
                            .font(.headline)
                        Text("Detect objects drawing materials such as crayon boxes and display 3D UI.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                NavigationLink(destination: DrawingClassificationView()) {
                    VStack(alignment: .leading) {
                        Text("Drawing Classification with MNIST")
                            .font(.headline)
                        Text("Classify drawn digits using MNIST model.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Explore Machine Learning Models")
        }

    }
}

#Preview {
    MachineLearningModelsView(appState: AppState(), immersiveSpaceIdentifier: "Debbie from ML View")
}

