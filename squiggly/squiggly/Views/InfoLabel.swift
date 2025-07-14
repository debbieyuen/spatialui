//
//  ReferenceObjectLoader.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/13/25.
//  Resources: https://developer.apple.com/documentation/visionos/exploring_object_tracking_with_arkit
//  https://www.youtube.com/watch?v=NaB_6hLzYN0&t=151s
//

import SwiftUI

struct InfoLabel: View {
    let appState: AppState
    
    var body: some View {
        if let infoMessage {
            Text(infoMessage)
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
    }

    @MainActor
    var infoMessage: String? {
        if !appState.allRequiredProvidersAreSupported {
            return "Sorry, this app requires functionality that isn't supported on this platform."
        } else if !appState.allRequiredAuthorizationsAreGranted {
            return "Sorry, this app is missing necessary authorizations. You can change this in the Privacy & Security settings."
        }
        return nil
    }
}
