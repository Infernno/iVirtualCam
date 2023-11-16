import SwiftUI
import AVFoundation
import Shared
import Defaults

struct CameraView: View {
    
    @EnvironmentObject private var cameraRepository: CameraRepository
    
    @Default(.inputCameraDeviceId) var selectedCameraId: String
    
    @State var inputCameras: [AVCaptureDevice] = []
    @State var virtualCamera: AVCaptureDevice? = nil
    
    var body: some View {
        VStack {
            Picker("Select input camera", selection: $selectedCameraId) {
                ForEach(inputCameras, id: \.uniqueID) { camera in
                    Text(camera.localizedName)
                        .tag(camera.uniqueID)
                }
            }.frame(width: 400)
            
            Divider()
            
            Text("Virtual camera").font(.title3)
            
            ZStack {
                AVDeviceView(
                    device: $virtualCamera,
                    placeholder:  {
                        ZStack {
                            Rectangle().fill(.black)
                            Text("Ops, virtual camera is not available :(")
                        }
                    }
                )
            }.cornerRadius(20)
        }
        .padding()
        .onAppear(perform: refreshCameras)
        .onReceive(NotificationCenter.default.forEvents(
            NSNotification.Name.AVCaptureDeviceWasConnected,
            NSNotification.Name.AVCaptureDeviceWasDisconnected
        )
        ) { notification in
            refreshCameras()
        }
    }
    
    private func refreshCameras() {
        inputCameras = cameraRepository.getAllCameras()
        virtualCamera = cameraRepository.getVirtualCamera()
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
