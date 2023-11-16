import SwiftUI
import AVFoundation
import SystemExtensions
import Shared

struct SettingsView: View {
    
    @StateObject private var installer = CameraExtensionInstaller()
    @State private var installerStatus: String? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            SectionGroup("System extension") {
                VStack(alignment: .leading) {
                    Button("Install extension") {
                        installer.install()
                    }
                    
                    Button("Uninstall extension") {
                        installer.uninstall()
                    }
                    
                    if let status = installerStatus {
                        Divider()
                        Text(status)
                    }
                }.frame(maxWidth: .infinity)
            }
            
            SectionGroup("System extension") {
                VStack(alignment: .leading) {
                    Button("Install extension") {
                        installer.install()
                    }
                    
                    Button("Uninstall extension") {
                        installer.uninstall()
                    }
                    
                    if let status = installerStatus {
                        Divider()
                        Text(status)
                    }
                }.frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.red.opacity(0.1))
        .padding()
        .onChange(of: installer.state) { newState in
            installerStatus = updateStatus(newState)
        }
    }
    
    private func updateStatus(_ state: CameraExtensionInstaller.State) -> String? {
        switch(state) {
        case .none:
            return nil
        case .failure(let error):
            return error
        case .success(let needsReboot):
            return needsReboot ? "Success. Needs reboot" : "Success"
        case .needsUserApproval:
            return "Needs approval"
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

    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { isGranted in
            // hasCameraPermission = isGranted
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
