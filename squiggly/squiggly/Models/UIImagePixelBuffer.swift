//
//  UIImagePixelBuffer.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/18/25.
//

import CoreVideo
import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }

    func toCVPixelBuffer() -> CVPixelBuffer? {
        guard let resizedImage = self.resized(to: CGSize(width: 28, height: 28)) else { return nil }

        let attrs: [NSObject: AnyObject] = [
            kCVPixelBufferCGImageCompatibilityKey: true as CFBoolean,
            kCVPixelBufferCGBitmapContextCompatibilityKey: true as CFBoolean
        ]
        var pixelBuffer: CVPixelBuffer?
        let width = Int(resizedImage.size.width)
        let height = Int(resizedImage.size.height)
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height,
                                         kCVPixelFormatType_OneComponent8, attrs as CFDictionary, &pixelBuffer)
        guard status == kCVReturnSuccess, let pb = pixelBuffer else { return nil }

        CVPixelBufferLockBaseAddress(pb, [])
        let context = CGContext(data: CVPixelBufferGetBaseAddress(pb),
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: CVPixelBufferGetBytesPerRow(pb),
                                space: CGColorSpaceCreateDeviceGray(),
                                bitmapInfo: CGImageAlphaInfo.none.rawValue)
        guard let ctx = context else {
            CVPixelBufferUnlockBaseAddress(pb, [])
            return nil
        }

        UIGraphicsPushContext(ctx)
        resizedImage.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pb, [])

        return pb
    }
}

