//
//  ReferenceObjectLoader.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/13/25.
//  Resources: https://developer.apple.com/documentation/visionos/exploring_object_tracking_with_arkit
//  https://www.youtube.com/watch?v=NaB_6hLzYN0&t=151s
//

import SwiftUI
import ARKit

struct ListEntryView: View {
    var referenceObject: ReferenceObject
    var referenceObjectLoader: ReferenceObjectLoader
    
    var body: some View {
        let binding = Binding(
            get: { referenceObjectLoader.enabledReferenceObjects.contains(referenceObject) },
            set: { enabled in
                if enabled {
                    referenceObjectLoader.enabledReferenceObjects.append(referenceObject)
                } else {
                    referenceObjectLoader.enabledReferenceObjects.removeAll(where: { $0.id == referenceObject.id })
                }
            }
        )
        
        Toggle(isOn: binding, label: {
            Text("\(referenceObject.name)")
        })
    }
}
