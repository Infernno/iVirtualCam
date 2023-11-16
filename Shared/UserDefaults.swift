import Defaults
import Foundation

public let defaults = UserDefaults(suiteName: "MBQLD47ZQV.com.infernno.iVirtualCam.appgroup")!
public let noneDeviceID = "cameraNone"

extension Defaults.Keys {
    public static let inputCameraDeviceId = Key<String>("inputCameraDeviceId", default: noneDeviceID, suite: defaults)
}
