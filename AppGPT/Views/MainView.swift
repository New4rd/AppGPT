
import SwiftUI

struct MainView: View, Decodable, Encodable, Hashable {
        
    var body: some View {
        Group {
            ConversationView()
        }

    }
}
