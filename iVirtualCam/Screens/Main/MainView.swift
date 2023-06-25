import SwiftUI
import AVFoundation
import Shared

struct MainView: View {
    
    @State private var inputCameras: [AVCaptureDevice] = []
    
    @State private var inputSelection: AVCaptureDevice? = nil
    @State private var outputSelection: AVCaptureDevice? = nil
    
    var body: some View {
        HStack {
            VStack {
                Text("Select an input camera")
                Picker("Input camera", selection: $inputSelection) {
                    ForEach($inputCameras, id: \.self) { d in
                        Text(d.wrappedValue.localizedName)
                            .tag(AVCaptureDevice?.some(d.wrappedValue))
                        Divider()
                    }
                }
                
                AVCameraView(
                    device: $inputSelection,
                    placeholder: "Test"
                )
                
            }.frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            
            Divider()
            
            VStack {
                Text("Output camera")
                Text(VirtualCameraDeviceName)
                
                AVCameraView(
                    device: $outputSelection,
                    placeholder: "Test"
                )
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
        }.onAppear {
            setupCameras()
        }
    }
    
    
    private func setupCameras() {
        let types = [
            AVCaptureDevice.DeviceType.builtInWideAngleCamera,
            AVCaptureDevice.DeviceType.externalUnknown
        ]
        
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: types,
            mediaType: .video,
            position: .unspecified
        )
        
        let devices = discoverySession.devices
        
        for device in devices {
            if device.localizedName == VirtualCameraDeviceName {
                outputSelection = device
            }
            else {
                inputCameras.append(device)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
