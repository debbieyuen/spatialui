//
//  AboutView.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/19/25.
//

import SwiftUI
import RealityKit
import RealityKitContent
import ARKit

struct AboutView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack(spacing: 0) {
                // Left side
                VStack(alignment: .leading) {
                    Text("Welcome to Vancouver")
                        .font(.largeTitle)
                        .padding(.bottom, 15)
                        .accessibilitySortPriority(4)
                    
                    Text("Thank you for joining our session today at SIGGRAPH Vancouver! We are excited to have you join us. Here, you will find our demo application that you may experiment with as you wish. Try modifying the code and creating your own user interfaces. Please do not hesitate to raise your hands if you have any questions.").accessibilitySortPriority(3)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(40)

                // Right Side
                VStack {
                    RealityView { content in
                        if let entity = try? await Entity(named: "PinkPixel22", in: realityKitContentBundle) {
                            entity.scale = SIMD3<Float>(repeating: 0.65)
                            entity.position.y += 0.1   // move up 0.2 meters
                            entity.position.x -= 0.03   // move left 0.1 meters (negative X is left)
                            entity.position.z -= 0.1
                            content.add(entity)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding(50)
            }
        }
    }
}

//@ViewBuilder
//func topButton(title: String, url: String) -> some View {
//    Button(action: {
//        if let link = URL(string: url) {
//            UIApplication.shared.open(link)
//        }
//    }) {
//        HStack {
//            Text(title)
//            //            Image(systemName: "arrow.right")
//        }
//    }
//}

#Preview {
    AboutView()
}
