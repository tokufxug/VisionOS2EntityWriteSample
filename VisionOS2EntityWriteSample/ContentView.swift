//
//  ContentView.swift
//  VisionOS2EntityWriteSample
//
//  Created by Sadao Tokuyama on 8/25/24.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    
    @State var mainEntity: Entity?
    @State var realityURL: URL?
    
    var body: some View {
        HStack {
            RealityView { content in
                if let entity = try? await Entity(named: "toy_drummer_idle") {
                    mainEntity = entity
                    mainEntity?.scale = [0.02, 0.02, 0.02]
                    mainEntity?.position.z-=0.3
                    mainEntity?.position.x-=0.1
                    content.add(mainEntity!)
                }
            }
            if realityURL != nil {
                Model3D(url: realityURL!) {phase in
                    if let model = phase.model {
                        model
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else if phase.error != nil {
                        VStack {
                            Image(systemName: "x.circle.fill")
                                .font(.extraLargeTitle2)
                            Text("Failed to load.")
                        }
                    } else {
                        ProgressView()
                    }
                }
            }
            
            Button(action: {
                let fileManager = FileManager.default
                let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
                if let documentsURL = urls.first {
                    let fileURL = documentsURL.appendingPathComponent("entity.reality")
                    Task {
                        try await mainEntity?.write(to: fileURL)
                        print("File saved at: \(fileURL.path)")
                        realityURL = fileURL
                    }
                }
            }){
                Text("Save")
                    .font(.extraLargeTitle)
            }
            .padding()
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
