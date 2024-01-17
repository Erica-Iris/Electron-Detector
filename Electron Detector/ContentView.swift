//
//  ContentView.swift
//  Electron Detector
//
//  Created by Iris on 1/17/24.
//

import AppKit
import SwiftUI

struct ContentView: View {
    @State private var electronApps: [String] = []
    @StateObject private var appFetcher = ElectronAppFetcher()

    var body: some View {
        GeometryReader { geometry in
            // 使用GeometryReader读取当前视图的宽度
            let width = geometry.size.width

            // 根据宽度计算每行的卡片数量
            let columns = calculateColumns(for: width, minimumCardWidth: 100)

            VStack(alignment: .center, spacing: 0) {
                Text("You get \(electronApps.count) chrome on your mac!")
                    .bold()
                    .font(.title)
                    .padding(.top, 8)
                // 创建网格布局
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(electronApps.indices, id: \.self) { i in
                            IconView(appname: electronApps[i])
                        }
                    }
                    .padding()
                }
            }
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

#Preview {
    ContentView()
}

extension ContentView {
    func calculateColumns(for width: CGFloat, minimumCardWidth: CGFloat) -> [GridItem] {
        let numberOfItems = max(1, Int(width / minimumCardWidth))
        return Array(repeating: GridItem(.flexible(), spacing: 20), count: numberOfItems)
    }
}
