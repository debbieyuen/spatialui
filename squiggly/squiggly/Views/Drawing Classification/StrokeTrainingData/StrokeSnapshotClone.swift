//
//  StrokeSnapshotClone.swift
//  squiggly
//
//  Created by Debbie Yuen on 8/2/25.
//

//  SnapshotSceneBuilder.swift
//  squiggly
//
//  Created by Debbie Yuen on 8/2/25.
//

import RealityKit

func strokeSnapshotClone(from strokes: [Stroke]) -> Entity {
    let snapshotRoot = Entity()
    for stroke in strokes {
        let clone = stroke.entity.clone(recursive: true)
        snapshotRoot.addChild(clone)
    }
    return snapshotRoot
}
