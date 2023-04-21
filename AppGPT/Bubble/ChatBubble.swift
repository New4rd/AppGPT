
import Foundation
import SwiftUI

struct ChatBubble: View {
    
    @State private var textValue: String
    @State private var textAlignment: TextAlignment
    @State private var bubbleColor: Color
    @State private var bubbleTextColor: Color
    @State private var bubbleAlignment: Alignment
    
    @State private var isVisible: Bool = false
    
    var body: some View {
    
        HStack {
            
            Spacer(minLength: bubbleAlignment == .leading ? 0 : 50)
            
            Text (textValue)
                .padding()
                .multilineTextAlignment(textAlignment)
                .foregroundColor(bubbleTextColor)
                .background(Rectangle().fill(bubbleColor).cornerRadius(15))
                .frame(maxWidth: .infinity, alignment: bubbleAlignment)
                .fixedSize(horizontal: false, vertical: true)
            
            
                .opacity(isVisible ? 1 : 0)
                .animation(.easeIn(duration: 0.5), value: isVisible)
            .onAppear { isVisible = true }

            Spacer(minLength: bubbleAlignment == .trailing ? 0 : 50)
        }
    }
    
    init(chatBubbleData: ChatBubbleData) {
        
        textValue = chatBubbleData.text
        textAlignment = chatBubbleData.type == .user ? .trailing: .leading
        
        switch chatBubbleData.type {
        case .user: bubbleColor = .blue
        case .system: bubbleColor = .red
        case .assistant: bubbleColor = Color(red: 0.925, green: 0.925, blue: 0.925)
        }
        
        bubbleTextColor = chatBubbleData.type == .assistant ? .black: .white
        bubbleAlignment = chatBubbleData.type == .user ? .trailing: .leading
    }
}
