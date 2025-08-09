//
//  ImageFile.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/6/25.
//  Resource: https://developer.apple.com/documentation/visionos/accessing-the-main-camera
//

import Foundation
import Vision

struct ImageFile {
    var url: URL? = nil
    var observations: [String: VNConfidence] = [:]
}
