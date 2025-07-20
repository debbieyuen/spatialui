//
//  DrawView.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/20/25.
//

import SwiftUI

struct DrawView: View {
    @State private var selectedColor: Color = .pink
    var body: some View {
            ColorPicker("Pick a color", selection: $selectedColor)
    }
}

#Preview {
    DrawView()
}
