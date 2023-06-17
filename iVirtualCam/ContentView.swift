//
//  ContentView.swift
//  iVirtualCam
//
//  Created by vladislav on 14.06.2023.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @StateObject var navigator: Navigator
    
    var body: some View {
        VStack {
            let destination = navigator.destination
            
            switch(destination) {
            case .start:
                StartView()
            case .main:
                MainView()
            }
        }
        .environmentObject(navigator)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(navigator: Navigator(destination: .start))
    }
}
