import SwiftUI

struct UnderConstructionView: View {
    var body: some View {
        VStack {
            Image(systemName: "fireworks")
            Spacer().frame(height: 30)
            Text("Work in progress")
        }
    }
}

struct UnderConstructionView_Previews: PreviewProvider {
    static var previews: some View {
        UnderConstructionView()
    }
}
