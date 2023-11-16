import AVFoundation
import Shared

class CameraRepository: ObservableObject {
    
    func getAllCameras() -> Array<AVCaptureDevice> {
        return getVideoDevices()//.map { device in
          //  Camera(id: device.uniqueID, name: device.localizedName)
      //  }
    }
    
    func getVirtualCamera() -> AVCaptureDevice? {
        return nil
      //  return getVideoDevices().first { $0.localizedName == VirtualCameraDeviceName }
    }
    
    private func getVideoDevices() -> Array<AVCaptureDevice> {
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
        
        return discoverySession.devices
    }
}
