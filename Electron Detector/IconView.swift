//
//  IconView.swift
//  Electron Detector
//
//  Created by Iris on 1/17/24.
//

import AppKit
import SwiftUI

struct ElectronAppInfo: Identifiable {
    let id = UUID()
    var name: String
    var icon: NSImage?
}

class ElectronAppFetcher: ObservableObject {
    @Published var appname: String!
    func fetchApplicationIcons() -> [ElectronAppInfo] {
        let fileManager = FileManager.default
        let applicationsURL = URL(fileURLWithPath: "/Applications", isDirectory: true)
        var apps: [ElectronAppInfo] = []

        do {
            // 获取 /Applications 目录下的所有条目
            let appURLs = try fileManager.contentsOfDirectory(at: applicationsURL, includingPropertiesForKeys: nil)
            print(appURLs)

            for appURL in appURLs {
                // 确保路径是.app结尾
                if appURL.pathExtension == "app" {
                    // 使用NSWorkspace获取应用程序的图标
                    let icon = NSWorkspace.shared.icon(forFile: appURL.path)

                    let appName = Bundle(url: appURL)?.localizedInfoDictionary?["CFBundleName"] as? String
                        ?? Bundle(url: appURL)?.infoDictionary?["CFBundleName"] as? String
                        ?? appURL.deletingPathExtension().lastPathComponent

                    apps.append(ElectronAppInfo(name: appName, icon: icon))
                }
            }
        } catch {
            print("Error while fetching applications: \(error)")
        }

        return apps
    }

    func getIcon(for fileURL: String) -> NSImage {
        return NSWorkspace.shared.icon(forFile: fileURL)
    }

    func makeNameLegal(appname: String) -> String {
        let appname = appname.lowercased()
        if appname.contains("applications") {
            return NSString(string: appname).lastPathComponent
        } else {
            return appname
        }
    }

    func getApplicationIcon(appName: String) -> NSImage {
        let fileManager = FileManager.default
        let legalAppName = self.makeNameLegal(appname: appName)
        print(legalAppName)
        let appPath = "/Applications/\(legalAppName)"
        let systemAppPath = "/System/Applications/\(legalAppName)"

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

    func fetchApplicationIconsByName(searchString: String) -> NSImage {
        let fileManager = FileManager.default
        let appPath = searchString
        let systemAppPath = "/System\(searchString).app"

        // 检查标准应用目录
        if fileManager.fileExists(atPath: appPath) {
            return NSWorkspace.shared.icon(forFile: appPath)
        }

        // 检查系统应用目录
        if fileManager.fileExists(atPath: systemAppPath) {
            return NSWorkspace.shared.icon(forFile: systemAppPath)
        }

        // 如果应用不存在，返回默认图标
        return NSImage()
    }
}

struct IconView: View {
    var appFetcher: ElectronAppFetcher = .init()
    var appname: String
    var body: some View {
        VStack(spacing: 0) {
            Image(nsImage: self.appFetcher.getApplicationIcon(appName: self.appname))
                .resizable()
                .frame(width: 80, height: 80)
            VStack(alignment: .leading, spacing: 4) {
                Text(self.appFetcher.makeNameLegal(appname: self.appname))
                    .bold()
                    .frame(width: 80, alignment: .center)
                    .font(.subheadline)
                    .padding(.bottom, 8)
            }
        }
        .background(Color.gray.opacity(0.2))
        .clipShape(
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
    }
}

struct IconViewTestView: View {
    var body: some View {
        IconView(appname: "telegram.app")
        IconView(appname: "/Applications/news.app")
        IconView(appname: "warp.app")
        IconView(appname: "Snipaste.app")
    }
}

#Preview {
    IconViewTestView()
}
