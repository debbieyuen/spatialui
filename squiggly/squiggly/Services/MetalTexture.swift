//
//  Untitled.swift
//  squiggly
//
//  Created by Debbie Yuen on 8/1/25.
//

import MetalKit
import CoreGraphics

extension MTLTexture {
    func toCGImage() -> CGImage? {
        let width = self.width
        let height = self.height
        let pixelByteCount = 4
        let bytesPerRow = width * pixelByteCount
        let byteCount = bytesPerRow * height

        var rawData = [UInt8](repeating: 0, count: byteCount)
        let region = MTLRegionMake2D(0, 0, width, height)
        self.getBytes(&rawData, bytesPerRow: bytesPerRow, from: region, mipmapLevel: 0)

        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        guard let providerRef = CGDataProvider(data: NSData(bytes: &rawData, length: byteCount)) else {
            return nil
        }

        return CGImage(
            width: width,
            height: height,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo,
            provider: providerRef,
            decode: nil,
            shouldInterpolate: false,
            intent: .defaultIntent
        )
    }
}
