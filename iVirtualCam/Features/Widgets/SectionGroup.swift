import SwiftUI
import Foundation

struct SectionGroup<Content: View>: View {
    
    let title: String?
    @ViewBuilder let content: Content
    
    init(_ title: String? = nil, @ViewBuilder content:  () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body : some View {
        VStack(alignment: .leading) {
            if let title = title {
                VStack {
                    Text(title)
                        .bold()
                    
                    Spacer().frame(height: 8)
                }.padding(.leading, 8)
            }

            ZStack {
                content
            }
            .padding(.all, 10)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.secondary.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(Color.secondary.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

struct SectionGroup_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SectionGroup("Settings") {
                VStack {
                    HStack {
                        Text("Wi-Fi")
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Wi-Fi")
                    }
                }
            }
            
            Spacer().frame(height: 30)
            
            SectionGroup {
                VStack {
                    HStack {
                        Text("Wi-Fi")
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Wi-Fi")
                    }
                }
            }
        }
    }
}
