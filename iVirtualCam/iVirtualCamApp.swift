//
//  iVirtualCamApp.swift
//  iVirtualCam
//
//  Created by vladislav on 14.06.2023.
//

import SwiftUI

@main
struct iVirtualCamApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(navigator: Navigator(destination: .start))
        }
    }
}
