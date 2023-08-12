import SwiftUI

struct BlurView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {

    }
}

struct BlurView_Previews: PreviewProvider {
    static var previews: some View {
        BlurView()
    }
}
