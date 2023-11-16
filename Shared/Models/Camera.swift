
public struct Camera: Identifiable {
    public let id: String
    public let name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

extension Camera {
    public static let none: Camera = Camera(id: noneDeviceID, name: "-------")
}
