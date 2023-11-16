import SwiftUI
import AVFoundation

private enum MenuId {
    case camera
    case settings
}

private struct MenuItem: Identifiable, Hashable {
    let id: MenuId
    let name: String
    let image: String
}

private let menuItems = [
    MenuItem(id: .camera, name: "Camera", image: "camera.aperture"),
    MenuItem(id: .settings, name: "Settings", image: "slider.horizontal.3"),
]

struct ContentView: View {
    
    @State private var selectedScreen: MenuId = .settings
    
    var body: some View {
        NavigationSplitView(
            sidebar: {
                List(menuItems, selection: $selectedScreen) { item in
                    Label(item.name, systemImage: item.image)
                }
                .toolbar(.hidden, for: .windowToolbar)
            },
            detail: {
                switch(selectedScreen) {
                case .camera:
                    CameraView()
                case .settings:
                    SettingsView()
                default:
                    UnderConstructionView()
                }
            }
        )
        .environmentObject(CameraRepository())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
