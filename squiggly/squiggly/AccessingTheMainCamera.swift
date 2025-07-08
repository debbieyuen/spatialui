//
//  AccessingTheMainCamera.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/7/25.
//  Resource: https://developer.apple.com/documentation/visionos/accessing-the-main-camera
//

import SwiftUI

struct AccessingTheMainCameraApp: App {
    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
     }
}
