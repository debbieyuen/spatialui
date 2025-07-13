//
//  MachineLearningModelsView.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/11/25.
//

import SwiftUI

struct MachineLearningModelsView: View {
    var appState: AppState
    var immersiveSpaceIdentifier: String
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Photo Classification") {
                    PhotoClassificationView()
                }
                NavigationLink("Object Detection with Vision and FastViT") {
                    CrayonObjectDetectionView(appState: appState, immersiveSpaceIdentifier: immersiveSpaceIdentifier)
                }
                NavigationLink("Drawing Classification with MNIST") {
                    DrawingClassificationView()
                }
            }
            .navigationTitle("Explore Machine Learning Models")
        }
    }
}

#Preview {
    MachineLearningModelsView(appState: AppState(), immersiveSpaceIdentifier: "Debbie from ML View")
}

