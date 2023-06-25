import AppKit
import AVFoundation
import SwiftUI

struct AVCameraView: View {
    @Binding var device: AVCaptureDevice?
    @State private var session: AVCaptureSession? = nil
    
    @State var placeholder: String
    
    var body : some View {
        ZStack {
            if(session == nil) {
                Rectangle()
                    .fill(.black)
                Text(placeholder)
            }
            else {
                AVCaptureViewRepresentable(session: session!)
            }
        }
        .onAppear {
            startSession()
        }
        .onDisappear {
            stopSession()
        }
        .onChange(of: device) { newDevice in
            restartSession()
        }
    }
    
    private func startSession() {
        if device != nil {
            session = getCaptureSession(device: device!)
            session?.startRunning()
        }
    }
    
    private func stopSession() {
        session?.stopRunning()
    }
    
    private func restartSession() {
        stopSession()
        startSession()
    }
    
    private func getCaptureSession(device: AVCaptureDevice) -> AVCaptureSession? {
        do {
            let session = AVCaptureSession()
            let videoInput = try AVCaptureDeviceInput(device: device)
            
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
                
                return session
            }
        }
        catch {
            placeholder = error.localizedDescription
        }
        
        return nil
    }
}

/**
 * Preview for camera
 */
struct AVCaptureViewRepresentable: NSViewRepresentable {
    typealias NSViewType = AVCaptureVideoNSView
    
    let session: AVCaptureSession
    
    init(session: AVCaptureSession) {
        self.session = session
    }
    
    func makeNSView(context: Context) -> NSViewType {
        return AVCaptureVideoNSView(captureSession: session)
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        
    }
}

final class AVCaptureVideoNSView: NSView {
    
    init(captureSession: AVCaptureSession) {
        super.init(frame: .zero)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        previewLayer.frame = self.frame
        previewLayer.contentsGravity = .resizeAspect
        previewLayer.videoGravity = .resizeAspect
        
        previewLayer.connection?.automaticallyAdjustsVideoMirroring = false
        
        layer = previewLayer
        wantsLayer = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
