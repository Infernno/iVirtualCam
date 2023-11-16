import AppKit
import AVFoundation
import SwiftUI

struct AVDeviceView<Placeholder: View>: View {
    @Binding var device: AVCaptureDevice?
    @State private var session: AVCaptureSession = AVCaptureSession()
    
    @ViewBuilder let placeholder: Placeholder
    
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
    
    private func restartSession() {
        DispatchQueue.global().async { [weak session, weak device] in
            print("restartSession()")
            
            guard let session = session else {
                return
            }
            
            guard let device = device else {
                return
            }
            
            session.stopRunning()
            setupCamera(device, session)
            session.startRunning()
        }
    }
    
    private func startSession() {
        DispatchQueue.global().async { [weak session, weak device] in
            print("startSession()")
            
            guard let session = session else {
                return
            }
            
            if session.inputs.isEmpty {
                guard let device = device else {
                    return
                }
                
                setupCamera(device, session)
            }
            
            session.startRunning()
        }
    }
    
    private func stopSession() {
        DispatchQueue.global().async { [weak session] in
            print("stopSession()")
            session?.stopRunning()
        }
    }
    
    private func setupCamera(_ camera: AVCaptureDevice, _ session: AVCaptureSession) {
        session.beginConfiguration()
        
        do {
            // Remove all previous inputs
            session.inputs.forEach { input in
                session.removeInput(input)
            }
            
            let videoInput = try AVCaptureDeviceInput(device: camera)
            
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
            }
        }
        catch {
            // if let onErrorCallback = onError {
            //    onErrorCallback(error)
            // }
            
            print("Failed to capture session \(error)")
        }
        
        session.commitConfiguration()
    }
    
    /*
     private func startSession() {
     let isEmpty = session.inputs.isEmpty
     
     if isEmpty, let videoDevice = device {
     tryCaptureVideo(videoDevice)
     }
     
     DispatchQueue.global().async { [weak session] in
     session?.startRunning()
     }
     
     // session.startRunning()
     }
     
     private func stopSession() {
     DispatchQueue.global().async { [weak session] in
     session?.stopRunning()
     }
     //session.stopRunning()
     }
     
     private func restartSession() {
     // Remove all previous inputs
     session.inputs.forEach { input in
     session.removeInput(input)
     }
     
     stopSession()
     startSession()
     }
     
     private func tryCaptureVideo(_ device: AVCaptureDevice) {
     session.beginConfiguration()
     
     do {
     // Remove all previous inputs
     session.inputs.forEach { input in
     session.removeInput(input)
     }
     
     let videoInput = try AVCaptureDeviceInput(device: device)
     
     if session.canAddInput(videoInput) {
     session.addInput(videoInput)
     }
     }
     catch {
     // if let onErrorCallback = onError {
     //    onErrorCallback(error)
     // }
     
     print("Failed to capture session \(error)")
     }
     
     session.commitConfiguration()
     } */
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
