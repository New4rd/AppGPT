//
//  ConversationModel.swift
//  AppGPT
//
//  Created by Maxime Barre on 12/04/2023.
//

import Foundation
import SwiftOpenAI

public class ConversationModel : ObservableObject {
    
    public var readyToSendMsg: Bool = true
    
    //private let openAI: SwiftOpenAI = SwiftOpenAI(apiKey: "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")
    private let openAI: SwiftOpenAI = SwiftOpenAI(apiKey: StoredPreferences.GetTokenApiKey()!)
    
    private var messages: [MessageChatGPT] = []

    private var modelListeners: [ConversationModelListener] = []
    
    public func AddListener(listener: ConversationModelListener) -> Void {
        modelListeners.append(listener)
    }
    
    public func SendRequest(request: String) async -> Void {
    
        messages.append(MessageChatGPT(text: request, role: .user))
        let optionalParameters = ChatCompletionsOptionalParameters(temperature: StoredPreferences.GetTemperature(), maxTokens: StoredPreferences.GetMaxToken())
        readyToSendMsg = false
        
        do {
            let chatCompletions = try await openAI.createChatCompletions(model: .gpt3_5(.gpt_3_5_turbo_0301), messages: messages, optionalParameters: optionalParameters)
            
            readyToSendMsg = true
            messages.append(MessageChatGPT(text: (chatCompletions?.choices.first?.message.content)!, role: .assistant))
            
            for listener in modelListeners {
                listener.OnResultReceived(data: ChatBubbleData(type: .assistant, text: chatCompletions?.choices.first?.message.content ?? ""))
            }
            
        } catch {
            for listener in modelListeners {
                listener.OnResultReceived(data: ChatBubbleData(type: .system, text: error.localizedDescription))
            }
        }
    }
    
    func GetUglyMessage(errorDesc: String) -> String {
        return errorDesc.components(separatedBy: "\"")[3]
        
    }
}
