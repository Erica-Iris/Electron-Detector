//
//  IconView.swift
//  Electron Detector
//
//  Created by Iris on 1/17/24.
//

import AppKit
import SwiftUI

struct IconView: View {
    var appFetcher: ElectronAppFetcher = .init()
    var appname: String
    let cornerSize: Int = 14
    var body: some View {
        VStack(spacing: 0) {
            Image(nsImage: self.appFetcher.fetchApplicationIcon(appName: self.appname))
                .resizable()
                .frame(width: 80, height: 80)
            VStack(alignment: .leading, spacing: 4) {
                Text(self.appFetcher.makeNameLegal(appName: self.appname).uppercased())
                    .bold()
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .frame(width: 64,height: 20, alignment: .center)
                    .font(.subheadline)
                    .padding(.bottom, 8)
            }
        }
        .background(Color.gray.opacity(0.2))
        .clipShape(
            RoundedRectangle(cornerSize: CGSize(width: cornerSize, height: cornerSize)))
    }
}

struct IconViewTestView: View {
    var body: some View {
        IconView(appname: "telegram.app")
        IconView(appname: "/Applications/news.app")
        IconView(appname: "github desktop.app")
        IconView(appname: "Snipaste.app")
    }
}

#Preview {
    IconViewTestView()
}
