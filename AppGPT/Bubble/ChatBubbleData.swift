
import Foundation
import SwiftOpenAI

public struct ChatBubbleData: Hashable {
    
    var type: MessageRoleType
    var text: String
    
    public init (
        type: MessageRoleType,
        text: String
    ) {
        self.type = type
        self.text = text
    }
    
}

