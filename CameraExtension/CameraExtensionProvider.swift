import Foundation
import AVFoundation
import CoreMediaIO
import IOKit.audio
import os.log
import Shared
import CoreImage
import CoreImage.CIFilterBuiltins

let kFrameRate: Int = 60

class CameraExtensionDeviceSource: NSObject, CMIOExtensionDeviceSource, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private(set) var device: CMIOExtensionDevice!
    private var _streamSource: CameraExtensionStreamSource!
    private var _videoDescription: CMFormatDescription!
    
    private let captureSession = AVCaptureSession()
    private let imageProcessor = ImageProcessor()
    
    var availableProperties: Set<CMIOExtensionProperty> {
        return [.deviceTransportType, .deviceModel]
    }
    
    init(localizedName: String) {
        super.init()
        
        let deviceID = UUID() // replace this with your device UUID
        self.device = CMIOExtensionDevice(localizedName: localizedName, deviceID: deviceID, legacyDeviceID: nil, source: self)
        
        let dims = CMVideoDimensions(width: 1920, height: 1080)
        CMVideoFormatDescriptionCreate(allocator: kCFAllocatorDefault, codecType: kCVPixelFormatType_32BGRA, width: dims.width, height: dims.height, extensions: nil, formatDescriptionOut: &_videoDescription)
        
        let videoStreamFormat = CMIOExtensionStreamFormat.init(formatDescription: _videoDescription, maxFrameDuration: CMTime(value: 1, timescale: Int32(kFrameRate)), minFrameDuration: CMTime(value: 1, timescale: Int32(kFrameRate)), validFrameDurations: nil)
        
        let videoID = UUID() // replace this with your video UUID
        _streamSource = CameraExtensionStreamSource(localizedName: "SampleCapture.Video", streamID: videoID, streamFormat: videoStreamFormat, device: device)
        
        do {
            try device.addStream(_streamSource.stream)
        } catch let error {
            fatalError("Failed to add stream: \(error.localizedDescription)")
        }
        
        configureSession()
    }
    
    func deviceProperties(forProperties properties: Set<CMIOExtensionProperty>) throws -> CMIOExtensionDeviceProperties {
        let deviceProperties = CMIOExtensionDeviceProperties(dictionary: [:])
        
        if properties.contains(.deviceTransportType) {
            deviceProperties.transportType = kIOAudioDeviceTransportTypeVirtual
        }
        
        if properties.contains(.deviceModel) {
            deviceProperties.model = "SampleCapture Model"
        }
        
        return deviceProperties
    }
    
    func setDeviceProperties(_ deviceProperties: CMIOExtensionDeviceProperties) throws {
        // Handle settable properties here.
    }
    
    func startStreaming() {
        captureSession.startRunning()
        os_log("[VCAM]: captureSession.startRunning()")
    }
    
    func stopStreaming() {
        captureSession.stopRunning()
        os_log("[VCAM]: captureSession.stopRunning()")
        imageProcessor.clear()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let imageBuffer = sampleBuffer.imageBuffer {
            if(!imageProcessor.flipHorizontally(imageBuffer)) {
                os_log("[VCAM]: Failed to flip an image")
            }
        }
        
        _streamSource.stream.send(sampleBuffer, discontinuity: .time, hostTimeInNanoseconds: 0)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        os_log("[VCAM]: captureOutput missed frame (?)")
        _streamSource.stream.send(sampleBuffer, discontinuity: .sampleDropped, hostTimeInNanoseconds: 0)
    }
    
    private func applyFilterTo(_ inputImage: CIImage) -> CIImage? {
        return inputImage.transformed(by: CGAffineTransformMakeScale(-1, 1))
    }
    
    private func configureSession() {
        let output = AVCaptureVideoDataOutput()
        
        output.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA
        ]
        
        output.setSampleBufferDelegate(self, queue: .main)
        
        captureSession.beginConfiguration()
        captureSession.addOutput(output)
        
        let cameraId = "47B4B64B-7067-4B9C-AD2B-AE273A71F4B5"
        let input = findCaptureDevice(cameraId)
        
        captureSession.addInput(input!)
        
        captureSession.commitConfiguration()
    }
    
    private func findCaptureDevice(_ id: String) -> AVCaptureDeviceInput? {
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .externalUnknown, .deskViewCamera],
            mediaType: .video,
            position: .unspecified
        )
        
        let devices = discoverySession.devices
        
        guard let device = devices.first(where: { $0.uniqueID == id }) else { return nil }
        
        return try? AVCaptureDeviceInput(device: device)
    }
}
