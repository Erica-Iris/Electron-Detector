//
//  ContentView.swift
//  Electron Detector
//
//  Created by Iris on 1/17/24.
//

import SwiftUI

struct ContentView: View {
    @State private var electronApps: [String] = []
    @StateObject private var appFetcher = ElectronAppFetcher()
    var body: some View {
        VStack {
            Text("You have \(electronApps.count) chrome on your mac")
            List(electronApps, id: \.self) { appName in
                IconView(appname: appName)
            }
            .onAppear {
                // Run the shell script to find Electron apps and populate electronApps
                let script = Bundle.main.path(forResource: "main", ofType: "sh")
                let task = Process()
                task.launchPath = "/bin/zsh"
                task.arguments = [script ?? ""]

                let pipe = Pipe()
                task.standardOutput = pipe
                task.launch()

                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let output = String(data: data, encoding: .utf8) {
                    electronApps = output.components(separatedBy: "\n").filter { !$0.isEmpty }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
