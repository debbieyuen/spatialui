//
//  LeftPalette.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/22/25.
//  Resource: https://github.com/radicalappdev/Step-Into-Labs/blob/main/Step%20Into%20Labs/Labs/Lab007.swift
//  Resource: https://stepinto.vision/labs/lab-007-anchor-an-attachment-to-a-hand/
//  Resource: https://medium.com/@siddharth_70859/creating-a-hand-menu-in-vision-pro-with-swiftui-and-realitykit-d49f25428384
//

import SwiftUI
import UIKit

struct LeftUIPaletteView: View {
    @State private var userSelectedColor: Color = .pink
    var canvas: PaintingCanvas
    var body: some View {
        HStack(spacing: 5) {
            ColorPicker("", selection: $userSelectedColor).frame(width: 44, height: 44)
            // Reset the canvas or erase all
            Button {
                canvas.clearAll()
            } label: {
                Label("Eraser", systemImage: "eraser.fill")
            }
        }
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    LeftUIPaletteView(canvas: PaintingCanvas())
}
