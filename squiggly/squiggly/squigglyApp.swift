//
//  squigglyApp.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/2/25.
//  Resources: https://developer.apple.com/documentation/visionos/creating-your-first-visionos-app
//

import SwiftUI

@main
struct squigglyApp: App {
    var body: some Scene {
        WindowGroup {
            // Change opacity
            ContentView()
//                .background(.black.opacity(0.8))
        }
        ImmersiveSpace(id: "PaintingScene") {
            PaintingView()
        }
    }
}
