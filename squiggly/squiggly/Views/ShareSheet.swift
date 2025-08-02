//
//  ShareSheet.swift
//  squiggly
//
//  Created by Debbie Yuen on 8/2/25.
//

import SwiftUI
import UIKit

// We need this sheet because we want to share multiple files.
// Apple's native sharesheet shares one file at once. 
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
