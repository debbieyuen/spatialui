//
//  ImmersiveView.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/7/25.
//  Resource: https://developer.apple.com/documentation/visionos/accessing-the-main-camera
//

import SwiftUI
import RealityKit

struct ImmersiveView: View {
    var body: some View {
        VStack {
            // empty
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
