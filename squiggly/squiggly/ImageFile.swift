//
//  ImageFile.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/6/25.
//

import Foundation
import Vision

struct ImageFile {
    var url: URL? = nil
    var observations: [String: VNConfidence] = [:]
}
