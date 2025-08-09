//
//  CrayonObjectDetectionView.swift
//  squiggly
//
//  Created by Debbie Yuen on 7/12/25.
//  Resource: https://developer.apple.com/videos/play/wwdc2023/10095/
//

import SwiftUI
import ARKit
import RealityKit
import UniformTypeIdentifiers
import Combine

struct CrayonObjectDetectionView: View {
    @Bindable var appState: AppState
    let immersiveSpaceIdentifier: String
    
    // Get the Painting Canvas for resetting
    @Binding var selectedColor: Color
    @State private var userSelectedColor: Color = .pink
    
    // Share the json and images
    @State private var lastExportedJSONURL: URL?
    
    // Export the .json and .png files
    @State private var isExporting = false
    @State private var exportReady = false
    
    // Hide 3D reference objects when overlay is open
    @State private var isOverlayOpen = false
    
    let referenceObjectUTType = UTType("com.apple.arkit.referenceobject")!
    
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.scenePhase) private var scenePhase
    @State private var selectedReferenceObjectID: ReferenceObject.ID?
    @State private var fileImporterIsOpen = false
    @State private var shareItems: [Any] = []
    @State private var showShareSheet = false
    
    
    // Picking Colors
    //    @State private var userSelectedColor: Color = .pink
    var canvas: PaintingCanvas
    
    var body: some View {
        Group {
            if appState.canEnterImmersiveSpace {
                referenceObjectList
                    .frame(minWidth: 400, minHeight: 300)
            } else {
                InfoLabel(appState: appState)
                    .padding(.horizontal, 30)
                    .frame(minWidth: 400, minHeight: 300)
                    .fixedSize()
            }
        }
        .glassBackgroundEffect()
        .toolbar {
            ToolbarItem(placement: .bottomOrnament) {
                if appState.canEnterImmersiveSpace {
                    HStack {
                        if !appState.isImmersiveSpaceOpened {
                            // Start tracking the 3D Objects
                            Button {
                                //                            Button("Start Tracking \(appState.referenceObjectLoader.enabledReferenceObjectsCount) Object(s)") {
                                Task {
                                    switch await openImmersiveSpace(id: immersiveSpaceIdentifier) {
                                    case .opened:
                                        break
                                    case .error:
                                        print("An error occurred when trying to open the immersive space \(immersiveSpaceIdentifier)")
                                    case .userCancelled:
                                        print("The user declined opening immersive space \(immersiveSpaceIdentifier)")
                                    @unknown default:
                                        break
                                    }
                                }
                            } label: {
                                Label("Start", systemImage: "play.fill").foregroundColor(.green)
                            }
                            .disabled(!appState.canEnterImmersiveSpace || appState.referenceObjectLoader.enabledReferenceObjectsCount == 0)
                            
                        } else {
                            
                            Button {
                                Task {
                                    await dismissImmersiveSpace()
                                    appState.didLeaveImmersiveSpace()
                                }
                            } label: {
                                Label("Stop", systemImage: "stop.fill").foregroundColor(.red)
                            }
                            
                            // Share
                            Button(action: {
                                if !isExporting && !exportReady {
                                    // Capture images with virtual cameras
                                    prepareShareItems()
                                    
                                } else if exportReady {
                                    showShareSheet = true
                                }
                            }) {
                                Group {
                                    if isExporting {
                                        ProgressView()
                                    } else if exportReady {
                                        Label("Share", systemImage: "square.and.arrow.up").foregroundColor(.blue)
                                    } else {
                                        Label("Export", systemImage: "doc.badge.arrow.up")
                                    }
                                }
                            }
                            .disabled(isExporting)
                            
                            // Color Picker
                            ColorPicker("", selection: $userSelectedColor).frame(width: 44, height: 44)
                            
                            // Reset the canvas or erase all
                            Button {
                                canvas.clearAll()
                            } label: {
                                Label("Eraser", systemImage: "eraser.fill")
                            }
                        }
                    }
                }
            }
        }
        .fileImporter(isPresented: $fileImporterIsOpen, allowedContentTypes: [referenceObjectUTType], allowsMultipleSelection: true) { results in
            switch results {
            case .success(let fileURLs):
                Task {
                    // Try to load each selected file as a reference object.
                    for fileURL in fileURLs {
                        guard fileURL.startAccessingSecurityScopedResource() else {
                            print("Failed to get sandboxed access to the file \(fileURL)")
                            return
                        }
                        await appState.referenceObjectLoader.addReferenceObject(fileURL)
                        fileURL.stopAccessingSecurityScopedResource()
                    }
                }
            case .failure(let error):
                print("Failed to open file with error: \(error)")
            }
        }
        .onChange(of: scenePhase, initial: true) {
            print("CrayonObjectDetectionView scene phase: \(scenePhase)")
            if scenePhase == .active {
                Task {
                    // When returning from the background, check if the authorization has changed.
                    await appState.queryWorldSensingAuthorization()
                }
            } else {
                // Make sure to leave the immersive space if this view is no longer active
                // - such as when a person closes this view - otherwise they may be stuck
                // in the immersive space without the controls this view provides.
                if appState.isImmersiveSpaceOpened {
                    Task {
                        await dismissImmersiveSpace()
                        appState.didLeaveImmersiveSpace()
                    }
                }
            }
        }
        .onChange(of: appState.providersStoppedWithError, { _, providersStoppedWithError in
            // Immediately close the immersive space if an error occurs.
            if providersStoppedWithError {
                if appState.isImmersiveSpaceOpened {
                    Task {
                        await dismissImmersiveSpace()
                        appState.didLeaveImmersiveSpace()
                    }
                }
                
                appState.providersStoppedWithError = false
            }
        })
        .task {
            // Ask for authorization before a person attempts to open the immersive space.
            if appState.allRequiredProvidersAreSupported {
                await appState.requestWorldSensingAuthorization()
            }
        }
        .task {
            // Start monitoring for changes in authorization, in case the settings apps is in the foreground and changes authorizations there.
            await appState.monitorSessionEvents()
        }
        .sheet(isPresented: $showShareSheet, onDismiss: {
            exportReady = false
        }) {
            ShareSheet(activityItems: shareItems)
        }
    }
    
    @MainActor
    var referenceObjectList: some View {
        
        NavigationSplitView {
            VStack(alignment: .leading) {
                List(selection: $selectedReferenceObjectID) {
                    ForEach(appState.referenceObjectLoader.referenceObjects, id: \.id) { referenceObject in
                        ListEntryView(referenceObject: referenceObject, referenceObjectLoader: appState.referenceObjectLoader)
                    }
                    .onDelete { indexSet in
                        appState.referenceObjectLoader.removeObjects(atOffsets: indexSet)
                    }
                }
                .navigationTitle("Reference objects")
                
                Button {
                    fileImporterIsOpen = true
                } label: {
                    Image(systemName: "plus")
                }
                .padding(.leading)
                .help("Add reference objects")
            }
            .padding(.vertical)
            .disabled(appState.isImmersiveSpaceOpened)
            
        }
        detail: {
            if !appState.referenceObjectLoader.didFinishLoading {
                VStack {
                    Text("Loading reference objects…")
                    ProgressView(value: appState.referenceObjectLoader.progress)
                        .frame(maxWidth: 200)
                }
            } else if appState.referenceObjectLoader.referenceObjects.isEmpty {
                Text("Tap the + button to add reference objects, or include some in the 'Reference Objects' group of the app's Xcode project.")
            } else {
                if let selectedObject = appState.referenceObjectLoader.referenceObjects.first(where: { $0.id == selectedReferenceObjectID }) {
                    // Display the USDZ file that the reference object was displayed on in this detail view.
                    if let path = selectedObject.usdzFile, !fileImporterIsOpen {
                        Model3D(url: path) { model in
                            model
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(0.5)
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Text("No preview available")
                    }
                } else {
                    Text("No object selected")
                }
            }
        }
        
    }
    
    func shareImmediately(urls: [URL]) {
        shareItems = urls
        showShareSheet = true
    }
    
    func prepareShareItems() {
        isExporting = true
        exportReady = false
        shareItems = []
        
        Task {
            var itemsToShare: [Any] = []
            
            // Export strokes to JSON
            if let jsonURL = canvas.exportStrokesToJSONFile() {
                itemsToShare.append(jsonURL)
            }
            
            // Clone strokes to snapshot entity and take snapshots
            let snapshotRoot = strokeSnapshotClone(from: canvas.allStrokes)
            let snapshotURLs = await takeSnapshotsFromMultipleAngles(sceneRoot: snapshotRoot, allStrokes: canvas.allStrokes)
            itemsToShare.append(contentsOf: snapshotURLs)
            
            await MainActor.run {
                shareItems = itemsToShare
                isExporting = false
                exportReady = true
            }
        }
    }
    
}

//#Preview {
//    CrayonObjectDetectionView(appState: AppState(), immersiveSpaceIdentifier: "immersiveSpaceIdentifier")
//}
