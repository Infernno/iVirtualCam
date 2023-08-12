import SwiftUI
import AVFoundation
import SystemExtensions
import Shared

struct StartView: View {
    
    // @EnvironmentObject var navigator: Navigator
    
    @State private var hasCameraPermission: Bool = hasCameraPermission()
    @State private var isExtensionInstalled: Bool = isExtensionInstalled()
    
    @StateObject private var delegate = ConsoleDelegate()
    
    init() {
        navigate()
    }
    
    var body: some View {
        VStack {
            if(!isExtensionInstalled) {
                //Text("")
                Button("Install system extension") {
                    installSystemExtension()
                }
            }
            
            Spacer().frame(height: 30)
            
            if(!hasCameraPermission) {
                // Text("")
                Button("Grant access to camera") {
                    requestCameraPermission()
                }
            }
            
            Text(delegate.message)
            
            Spacer().frame(height: 30)
            
            Button("Uninstall extension") {
                uninstallSystemExtension()
            }
        }
    }
    
    private static func hasCameraPermission() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == AVAuthorizationStatus.authorized
    }
    
    private static func isExtensionInstalled() -> Bool {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.externalUnknown, .builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        
        for device in discoverySession.devices {
            if device.localizedName == VirtualCameraDeviceName {
                return true
            }
        }
        
        return false
    }
    
    private func installSystemExtension() {
        let request = OSSystemExtensionRequest.activationRequest(
            forExtensionWithIdentifier: CameraExtensionBundleID,
            queue: .main
        )
        
        request.delegate = delegate
        
        OSSystemExtensionManager.shared.submitRequest(request)
    }
    
    private func uninstallSystemExtension() {
        let activationRequest = OSSystemExtensionRequest.deactivationRequest(
            forExtensionWithIdentifier: CameraExtensionBundleID,
            queue: .main
        )
        activationRequest.delegate = delegate
        OSSystemExtensionManager.shared.submitRequest(activationRequest)
    }
    
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { isGranted in
            hasCameraPermission = isGranted
        }
    }
    
    private func navigate() {
        if(StartView.hasCameraPermission() && StartView.isExtensionInstalled()) {
            //  navigator.navigate(destination: NavigationDestination.main)
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}

class ConsoleDelegate: NSObject, OSSystemExtensionRequestDelegate, ObservableObject {
    
    @Published var message: String = "Log Text"
    
    func request(_ request: OSSystemExtensionRequest, actionForReplacingExtension existing: OSSystemExtensionProperties, withExtension ext: OSSystemExtensionProperties) -> OSSystemExtensionRequest.ReplacementAction {
        return .replace
    }
    
    func requestNeedsUserApproval(_ request: OSSystemExtensionRequest) {
        print("requestNeedsUserApproval: \(request)")
        message = "requestNeedsUserApproval"
    }
    
    func request(_ request: OSSystemExtensionRequest, didFinishWithResult result: OSSystemExtensionRequest.Result) {
        print("Extension result: \(result)")
        message = "Extension result: \(result)"
    }
    
    func request(_ request: OSSystemExtensionRequest, didFailWithError error: Error) {
        print("Failed to install extension: \(error)")
        message = ("Failed to install extension: \(error)")
    }
}
