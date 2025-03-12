//
//  ChatViewModel.swift
//  Lonelyn't
//
//  Created by José Luis Corral López on 12/3/25.
//

import SwiftUI

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isTyping: Bool = false

    func sendMessage() {
        guard !inputText.isEmpty else { return }

        let userMessage = ChatMessage(id: UUID(), text: inputText, isUser: true) // Agregar `id: UUID()`
        messages.append(userMessage)
        let userText = inputText
        inputText = ""
        
        isTyping = true

        ChatService.getAIResponse(for: userText) { response in
            DispatchQueue.main.async {
                self.isTyping = false
                if let reply = response {
                    let botMessage = ChatMessage(id: UUID(), text: reply, isUser: false)
                    self.messages.append(botMessage)
                } else {
                    let errorMessage = ChatMessage(id: UUID(), text: "Sorry, I couldn’t understand that.", isUser: false)  
                    self.messages.append(errorMessage)
                }
            }
        }
    }
}
