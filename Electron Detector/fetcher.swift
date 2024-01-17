//
//  fetcher.swift
//  Electron Detector
//
//  Created by Iris on 1/17/24.
//

import AppKit

class ElectronAppFetcher: ObservableObject {
    @Published var appname: String!

    private func getIcon(for fileURL: String) -> NSImage {
        return NSWorkspace.shared.icon(forFile: fileURL)
    }

    func makeNameLegal(appName: String) -> String {
        let appname = appName.lowercased()
        if appname.contains("applications") {
            return URL(fileURLWithPath: appname).deletingPathExtension().lastPathComponent
        } else {
            return String(appname.split(separator: ".")[0])
        }
    }

    func fetchApplicationIcon(appName: String) -> NSImage {
        let fileManager = FileManager.default

        let legalAppName = self.makeNameLegal(appName: appName)

        let appPath = "/Applications/\(legalAppName).app"
        let systemAppPath = "/System/Applications/\(legalAppName).app"

        // 检查标准应用目录
        if fileManager.fileExists(atPath: appPath) {
            return self.getIcon(for: appPath)
        }

        // 检查系统应用目录
        if fileManager.fileExists(atPath: systemAppPath) {
            return self.getIcon(for: systemAppPath)
        }

        // 如果应用不存在，返回默认图标
        return NSImage()
    }
}
