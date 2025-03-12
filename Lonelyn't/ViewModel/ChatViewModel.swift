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
        
        let newMessage = ChatMessage(id: UUID(), text: inputText, isUser: true)
        messages.append(newMessage)
        inputText = ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isTyping = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.isTyping = false
                self.messages.append(ChatMessage(id: UUID(), text: "This is an AI response.", isUser: false))
            }
        }
    }
}
