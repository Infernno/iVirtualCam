import Foundation
import Metal

class MetalContext {
    
    func test() {
        let device = MTLCreateSystemDefaultDevice()!
        let library = device.makeDefaultLibrary()
       // let function = try? device.makeComputePipelineState(function: <#T##MTLFunction#>)
        
        
    }
}
