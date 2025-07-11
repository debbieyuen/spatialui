//
//  ObjectTracking.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/11/25.
//

import SwiftUI

private enum UIIdentifier {
    static let immersiveSpace = "Object tracking"
}

@main
@MainActor
struct ObjectTrackingApp: App {
    @State private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            HomeView(
                appState: appState,
                immersiveSpaceIdentifier: UIIdentifier.immersiveSpace
            )
            .task {
                if appState.allRequiredProvidersAreSupported {
                    await appState.referenceObjectLoader.loadBuiltInReferenceObjects()
                }
            }
        }
        .windowStyle(.plain)

        ImmersiveSpace(id: UIIdentifier.immersiveSpace) {
            ObjectTrackingRealityView(appState: appState)
        }
    }
}
