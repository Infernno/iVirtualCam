import AppKit
import AVFoundation
import SwiftUI

struct AVDeviceView<Placeholder: View>: View {
    @Binding var device: AVCaptureDevice?
    @State private var session: AVCaptureSession = AVCaptureSession()
    
    @ViewBuilder let placeholder: Placeholder
    
    let onError: ((Error) -> Void)? = nil
    
    var body : some View {
        ZStack {
            if session.isRunning {
                AVCaptureViewRepresentable(session: session)
            }
            else {
                placeholder
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
        if session.inputs.isEmpty, let videoDevice = device {
            tryCaptureVideo(videoDevice)
        }
        
        session.startRunning()
    }
    
    private func stopSession() {
        session.stopRunning()
    }
    
    private func restartSession() {
        stopSession()
        startSession()
    }
    
    private func tryCaptureVideo(_ device: AVCaptureDevice) {
        do {
            // Remove all previous inputs
            session.inputs.forEach { input in
                session.removeInput(input)
            }
            
            let videoInput = try AVCaptureDeviceInput(device: device)
            
            if session.canAddInput(videoInput) {
                session.beginConfiguration()
                session.addInput(videoInput)
                session.commitConfiguration()
            }
        }
        catch {
            if let onErrorCallback = onError {
                onErrorCallback(error)
            }
            
            print("Failed to capture session \(error)")
        }
    }
}

/**
 * Preview for camera
 */
private struct AVCaptureViewRepresentable: NSViewRepresentable {
    typealias NSViewType = AVCaptureVideoNSView
    
    let session: AVCaptureSession
    
    init(session: AVCaptureSession) {
        self.session = session
    }
    
    func makeNSView(context: Context) -> NSViewType {
        return AVCaptureVideoNSView(captureSession: session)
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        nsView.updateSession(session)
    }
}

private final class AVCaptureVideoNSView: NSView {
    
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
    
    func updateSession(_ captureSession: AVCaptureSession) {
        if let previewLayer = layer as? AVCaptureVideoPreviewLayer {
            previewLayer.session = captureSession
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
