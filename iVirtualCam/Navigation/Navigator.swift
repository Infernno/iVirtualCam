import Foundation

class Navigator: ObservableObject {
    @Published var destination: NavigationDestination
    
    init(destination: NavigationDestination) {
        self.destination = destination
    }
    
    func navigate(destination: NavigationDestination) {
        self.destination = destination
    }
}
