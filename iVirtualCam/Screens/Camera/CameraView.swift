import SwiftUI
import AVFoundation
import Shared

struct CameraView: View {
    
    @StateObject private var viewModel = CameraViewModel()
    
    var body: some View {
        VStack {
            Picker("Select input camera", selection: $viewModel.inputSelection) {
                ForEach($viewModel.inputCameras, id: \.self) { d in
                    Text(d.wrappedValue.localizedName).tag(d.wrappedValue as AVCaptureDevice?)
                }
            }.frame(width: 400)
            
            Divider()
            
            Text("Virtual camera").font(.title3)
            Text("This is how others will see you").font(.body)
            
            AVDeviceView(
                device: $viewModel.inputSelection,
                placeholder:  {
                    ZStack {
                        Rectangle().fill(.black)
                        
                        Text("Ops, virtual camera is not available :(")
                    }
                }
            )
        }
        .padding()
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
