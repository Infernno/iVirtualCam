import CoreImage

import CoreVideo
import Metal
import MetalKit

class ImageProcessor {
    
    private let context = CIContext()
    private var buffer: CVPixelBuffer? = nil
    
    func flipHorizontally(_ imageBuffer: CVImageBuffer) -> Bool  {
        
        guard let outputPixelBuffer = getPixelBuffer(imageBuffer) else {
            return false
        }
        
        // Create a CIImage from the CVImageBuffer
        let ciImage = CIImage(cvImageBuffer: imageBuffer)
        
        // Apply a horizontal flip transformation
        let flippedImage = ciImage.oriented(.upMirrored)
        
        // Render the flipped image into the output pixel buffer
        context.render(flippedImage, to: outputPixelBuffer)
        
        // Lock the input image buffer
        CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)
        
        // Lock the output image buffer
        CVPixelBufferLockBaseAddress(outputPixelBuffer, .readOnly)
        
        // Get the base addresses of the input and output image buffers
        guard let inputBaseAddress = CVPixelBufferGetBaseAddress(imageBuffer),
              let outputBaseAddress = CVPixelBufferGetBaseAddress(outputPixelBuffer) else {
            return false
        }
        
        // Get the bytes per row of the input and output image buffers
        let inputBytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        let outputBytesPerRow = CVPixelBufferGetBytesPerRow(outputPixelBuffer)
        
        // Get the height of the input and output image buffers
        let height = CVPixelBufferGetHeight(imageBuffer)
        
        // Iterate over each row and copy the flipped image data to the input buffer
        for y in 0..<height {
            let inputRow = inputBaseAddress.advanced(by: y * inputBytesPerRow)
            let outputRow = outputBaseAddress.advanced(by: y * outputBytesPerRow)
            
            memcpy(inputRow, outputRow, inputBytesPerRow)
        }
        
        // Unlock the input image buffer
        CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly)
        
        // Unlock the output image buffer
        CVPixelBufferUnlockBaseAddress(outputPixelBuffer, .readOnly)
        
        return true
    }
    
    func clear() {
        buffer = nil
    }

    
    private func getPixelBuffer(_ imageBuffer: CVImageBuffer) -> CVPixelBuffer? {
        if buffer == nil || (CVPixelBufferGetHeight(imageBuffer) != CVPixelBufferGetHeight(buffer!)) || (CVPixelBufferGetWidth(imageBuffer) != CVPixelBufferGetWidth(buffer!)) {
            // Create a reusable pixel buffer to store the flipped image
            var pixelBuffer: CVPixelBuffer?
            let status = CVPixelBufferCreate(nil, CVPixelBufferGetWidth(imageBuffer), CVPixelBufferGetHeight(imageBuffer), CVPixelBufferGetPixelFormatType(imageBuffer), nil, &pixelBuffer)
            
            guard status == kCVReturnSuccess else {
                return nil
            }
            
            buffer = pixelBuffer
        }
        
        return buffer
    }
}
