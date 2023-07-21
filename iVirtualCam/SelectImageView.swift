import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct SelectImageView : View {
    
    @State private var selectedImageUrl: URL? = nil
    @State private var filteredImage: Image? = nil
    @State private var isSelected: Bool = false
    
    var body : some View {
        VStack {
            Button {
                isSelected = true
            } label: {
                Text("Select image")
            }
            
            HStack {
                if let imageUrl = selectedImageUrl {
                    AsyncImage(
                        url: imageUrl,
                        content: { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 1000)
                        },
                        placeholder: {
                            ProgressView()
                        }
                    )
                }
                
                if(filteredImage != nil && filteredImage != nil) {
                    Divider().frame(width: 1)
                }

                if(filteredImage != nil) {
                    filteredImage!.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 1000)
                }
            }
        }
        .fileImporter(isPresented: $isSelected, allowedContentTypes: [.image], onCompletion: { result in
            selectImage(result)
        }).padding()
    }
    
    private func selectImage(_ result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            selectedImageUrl = url
            applyFilter(url)
        case .failure(let error):
            print("Failed to select image: \(error)")
        }
    }
    
    private func applyFilter(_ url: URL) {
        guard let ciImage = CIImage(contentsOf: url) else { return }
        let ciContext = CIContext()
        
        let filter = CIFilter(name: "CIAffineTransform")!
        let value = CGAffineTransformMakeScale(-1, 1)
        
        filter.setValue(value, forKey: kCIInputTransformKey)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputImage = filter.outputImage else { return }
        
        if let cgimg = ciContext.createCGImage(outputImage, from: outputImage.extent) {
            filteredImage = Image(decorative: cgimg, scale: 1.0, orientation: .up)
        }
    }
}

class FlipFilter : CIFilter {
    private let delegate = CIFilter(name: "CIAffineTransform")!
    
    override var outputImage: CIImage? {
        get {
            return delegate.outputImage
        }
    }
    
    override var inputKeys: [String] {
        get {
            return delegate.inputKeys
        }
    }
    
    override var outputKeys: [String] {
        get {
            return delegate.outputKeys
        }
    }
    
    func setImage(_ image: CIImage) {
        delegate.setValue(image, forKey: kCIInputImageKey)
    }
    
    func setTransform() {
        let transform = CGAffineTransform().scaledBy(x: -1.0, y: 1.0)
        
        delegate.setValue(transform, forKey: kCIInputTransformKey)
    }
    
    override func apply(_ k: CIKernel, arguments args: [Any]?, options dict: [String : Any]? = nil) -> CIImage? {
        return delegate.apply(k, arguments: args, options: dict)
    }
}
