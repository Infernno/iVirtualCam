import SwiftUI

extension View {
    func fillParent() -> some View {
        return frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
