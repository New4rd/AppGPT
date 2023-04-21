
public protocol ConversationModelListener {
    func OnResultReceived(data: ChatBubbleData) -> Void
    func OnMessageSent() -> Void
}
