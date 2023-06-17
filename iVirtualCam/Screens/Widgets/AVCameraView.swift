import AppKit
import AVFoundation
import SwiftUI

/**
 * Preview for camera
 */
struct AVCaptureView: NSViewRepresentable {
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
        previewLayer.contentsGravity = .resizeAspectFill
        previewLayer.videoGravity = .resizeAspectFill
        
        previewLayer.connection?.automaticallyAdjustsVideoMirroring = false
        
        layer = previewLayer
        wantsLayer = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
