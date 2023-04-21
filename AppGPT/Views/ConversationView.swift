
import SwiftUI

struct ConversationView: View, ConversationModelListener {
    
    struct IndexedChatBubbleData : Hashable {
        public var chatBubbleData: ChatBubbleData
        public var index: Int
        
        init(chatBubbleData: ChatBubbleData, index: Int) {
            self.chatBubbleData = chatBubbleData
            self.index = index
        }
    }
    
    @State private var chatInput: String = ""
    @State var bubblesData: [IndexedChatBubbleData] = []
    @State var sendButtonLocked: Bool = false
    
    @State private var isVisible: Bool = false
    
    var body: some View {
        
        Color.white
            .ignoresSafeArea()
            .frame(minWidth: 500, minHeight: 300)
            .overlay(
        
        Group {
            VStack {
                ScrollViewReader { value in
                    ScrollView {
                        
                        VStack(spacing: 0) {
                            ForEach(bubblesData, id: \.self) { bubbleData in
                                ChatBubble(chatBubbleData: bubbleData.chatBubbleData)
                                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                            }
                        }
                    }
                    .onChange(of: bubblesData.count) { _ in
                        value.scrollTo(bubblesData.count-1)
                    }
                }

                
                /// Bottom bar
                HStack {
                    TextField (
                        "Interroger ChatGPT...",
                        text: $chatInput,
                        axis: .vertical
                    )
                    .controlSize(.large)
                    .multilineTextAlignment(.leading)
                    .frame(minWidth: 300)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        Task {
                            await SendMessage()
                        }
                    }
                    
                    Button(action: {
                        if !sendButtonLocked && !chatInput.description.isEmpty {
                            Task {
                                await SendMessage()
                            }
                        }
                    })
                    {
                        Text("Envoyer")
                            .foregroundColor((sendButtonLocked || chatInput.description.isEmpty ? Color(red: 174/255, green: 185/255, blue: 204/255) : .blue))
                            .bold()
                    }

                    .disabled((sendButtonLocked || chatInput.description.isEmpty))
                    .controlSize(.large)
                }
                
                .background(Rectangle()
                    .fill(Color(red: 0.95, green: 0.95, blue: 0.95))
                    .frame(height: 70)
                    .padding(EdgeInsets(top: 0, leading: -50, bottom: 0, trailing: -50)))
                
                .padding()
            }
            .padding(.top)
        }
        .onAppear() {
            OnViewAppeared()
        })
        
        .preferredColorScheme(.light)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction, content: {
                
                Button(action: {
                    ClearAllBubbles()
                }, label: {Text(verbatim: "Effacer")})
                .frame(alignment: .trailing)
                
            })
        }
    }
    
    public func ClearAllBubbles() -> Void {
        bubblesData.removeAll(keepingCapacity: false)
    }
        
    func SendMessage() async -> Void {
        let messageData = ChatBubbleData(type: .user, text: chatInput)
        chatInput = ""
        OnResultReceived(data: messageData)
        await conversationModel!.SendRequest(request: messageData.text)
    }
    
    public func OnResultReceived(data: ChatBubbleData) -> Void {
        bubblesData.append(IndexedChatBubbleData(chatBubbleData: data, index: Int.random(in: 100_000..<999_999)))
        sendButtonLocked = false
    }
    
    public func OnMessageSent() -> Void {
        sendButtonLocked = true
    }
    
    @State private var conversationModel: ConversationModel?
    
    func OnViewAppeared() -> Void {
        conversationModel = ConversationModel.init()
        conversationModel?.AddListener(listener: self)
    }
}
