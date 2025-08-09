//
//  PaintingCanvasSnapshot.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/18/25.
//

import UIKit

extension PaintingCanvas {
    func snapshotImage() -> UIImage? {
        let size = CGSize(width: 28, height: 28)
        let renderer = UIGraphicsImageRenderer(size: size)

        let allPoints3D = allStrokes.flatMap { $0.points }
        guard !allPoints3D.isEmpty else { return nil }

        let points2D = allPoints3D.map { CGPoint(x: CGFloat($0.x), y: CGFloat($0.y)) }
        let minX = points2D.map { $0.x }.min() ?? 0
        let minY = points2D.map { $0.y }.min() ?? 0
        let maxX = points2D.map { $0.x }.max() ?? 1
        let maxY = points2D.map { $0.y }.max() ?? 1

        let width = maxX - minX
        let height = maxY - minY
        let scale = max(width, height)

        let normalizedPoints2D = points2D.map { point -> CGPoint in
            let normX = (point.x - minX) / scale * 28
            let normY = (point.y - minY) / scale * 28
            return CGPoint(x: normX, y: 28 - normY)
        }

        let image = renderer.image { context in
            let ctx = context.cgContext

            ctx.setFillColor(UIColor.black.cgColor)
            ctx.fill(CGRect(origin: .zero, size: size))

            ctx.setStrokeColor(UIColor.white.cgColor)
            ctx.setLineWidth(2.0)
            ctx.setLineCap(.round)

            for stroke in allStrokes {
                let strokePoints = stroke.points.map { point -> CGPoint in
                    let normX = (CGFloat(point.x) - minX) / scale * 28
                    let normY = (CGFloat(point.y) - minY) / scale * 28
                    return CGPoint(x: normX, y: 28 - normY)
                }

                guard strokePoints.count > 1 else { continue }

                ctx.beginPath()
                ctx.move(to: strokePoints[0])

                for pt in strokePoints.dropFirst() {
                    ctx.addLine(to: pt)
                }

                ctx.strokePath()
            }
        }

        return image
    }
}
