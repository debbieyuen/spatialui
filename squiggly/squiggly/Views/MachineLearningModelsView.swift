//
//  MachineLearningModelsView.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/11/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct MachineLearningModelsView: View {
    @State private var selectedModelName: String = "Earth" // default model
    var appState: AppState
    var immersiveSpaceIdentifier: String

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // TOP: 3D Model Preview
                RealityView { content in
                    if let entity = try? await Entity(named: "Earth", in: realityKitContentBundle) {
                        content.add(entity)
                    }
                }
                .frame(maxHeight: .infinity)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 60) {
                        ForEach(modelItems) { item in
                            NavigationLink(destination: item.destinationView) {
                                Image(systemName: item.systemImage)
                                        .font(.largeTitle)
                                        .padding(.bottom)
                                VStack(alignment: .leading) {
                                    Text(item.title).font(.headline)
                                    Text(item.subtitle).font(.subheadline)
                                }
                                .padding()
                                .frame(width: 350, height: 120)
//                                .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.15)))
                            }
                            .buttonStyle(.plain)
                            .onHover { hovering in
                                if hovering {
                                    selectedModelName = item.modelName
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .frame(height: 150)
            }
            .navigationTitle("Exploring Machine Learning Models")
        }
    }

    // MARK: - ModelItem Struct
    struct ModelItem: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let modelName: String
        let systemImage: String
        let destinationView: AnyView
    }

    // MARK: - Model Items Data
    var modelItems: [ModelItem] {
        [
            ModelItem(
                title: "Photo Classification",
                subtitle: "Classify images from your photo library using Apple's built-in Vision framework and FastViT.",
                modelName: "Earth",
                systemImage: "photo.on.rectangle",
                destinationView: AnyView(PhotoClassificationView())
            ),
            ModelItem(
                title: "3D Object Detection",
                subtitle: "Detect physical drawing tools like crayon boxes using Apple's built-in Vision framework.",
                modelName: "CrayonBoxModel",
                systemImage: "cube.transparent",
                destinationView: AnyView(CrayonObjectDetectionView(appState: appState, immersiveSpaceIdentifier: UIIdentifier.immersiveSpace))
            ),
            ModelItem(
                title: "Text Classification",
                subtitle: "Read and analyze text with BertSquaD model.Read and analyze text with BertSquaD",
                modelName: "MNISTModel",
                systemImage: "text.alignleft",
                destinationView: AnyView(PhotoClassificationView())
            )
        ]
    }
}

#Preview {
    MachineLearningModelsView(appState: AppState(), immersiveSpaceIdentifier: UIIdentifier.immersiveSpace)
}

