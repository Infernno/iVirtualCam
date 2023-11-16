import Shared
import Foundation
import SystemExtensions

class CameraExtensionInstaller : NSObject, ObservableObject {
    
    @Published var state: State = .none
    
    func install() {
        let request = OSSystemExtensionRequest.activationRequest(
            forExtensionWithIdentifier: CameraExtensionBundleID,
            queue: .main
        )
        
        request.delegate = self
        
        OSSystemExtensionManager.shared.submitRequest(request)
    }
    
    func uninstall() {
        let request = OSSystemExtensionRequest.deactivationRequest(
            forExtensionWithIdentifier: CameraExtensionBundleID,
            queue: .main
        )
        
        request.delegate = self
        
        OSSystemExtensionManager.shared.submitRequest(request)
    }
    
    enum State: Equatable {
        case none
        case needsUserApproval
        case success(needsReboot: Bool)
        case failure(error: String)
    }
}

extension CameraExtensionInstaller : OSSystemExtensionRequestDelegate {
    func request(_ request: OSSystemExtensionRequest, actionForReplacingExtension existing: OSSystemExtensionProperties, withExtension ext: OSSystemExtensionProperties) -> OSSystemExtensionRequest.ReplacementAction {
        return .replace
    }
    
    func requestNeedsUserApproval(_ request: OSSystemExtensionRequest) {
        state = .needsUserApproval
    }
    
    func request(_ request: OSSystemExtensionRequest, didFinishWithResult result: OSSystemExtensionRequest.Result) {
        state = .success(needsReboot: result == .willCompleteAfterReboot)
    }
    
    func request(_ request: OSSystemExtensionRequest, didFailWithError error: Error) {
        state = .failure(error: error.localizedDescription)
    }
}
