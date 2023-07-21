import Foundation
import AVFoundation
import Shared
import SwiftUI

class CameraViewModel: ObservableObject {
    
    @Published var inputCameras: [AVCaptureDevice] = []
    @Published var inputSelection: AVCaptureDevice? = nil
    
    @Published var virtualCamera: AVCaptureDevice? = nil
    
    func onAppear() {
        print("onAppear()")
        
        setupCameras()
        setupCallback()
    }
    
    private func setupCameras() {
        print("Setup cameras called")
        
        let types: [AVCaptureDevice.DeviceType] = [
            .builtInWideAngleCamera,
            .deskViewCamera,
            .externalUnknown
        ]
        
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: types,
            mediaType: .video,
            position: .unspecified
        )
        
        let devices = discoverySession.devices
        
        print("Devices: \(devices)")
        
        //virtualCamera = devices.first { $0.localizedName == VirtualCameraDeviceName }
        inputCameras = devices//.filter { $0 != virtualCamera }
    }
    
    private func setupCallback() {
        NotificationCenter
            .default
            .addObserver(forName: NSNotification.Name.AVCaptureDeviceWasConnected,
                         object: nil,
                         queue: nil)
        { [weak self] (notif) -> Void in
            self?.setupCameras()
        }
        
        NotificationCenter
            .default
            .addObserver(forName: NSNotification.Name.AVCaptureDeviceWasDisconnected,
                         object: nil,
                         queue: nil)
        { [weak self] (notif) -> Void in
            self?.setupCameras()
        }
    }
    
    deinit {
        print("DESTROY !!___!!")
    }
}
