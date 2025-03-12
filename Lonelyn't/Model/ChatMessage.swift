//
//  ChatMessage.swift
//  Lonelyn't
//
//  Created by José Luis Corral López on 12/3/25.
//

import Foundation

struct ChatMessage: Identifiable {
    let id: UUID
    let text: String
    let isUser: Bool

    init(id: UUID = UUID(), text: String, isUser: Bool) {
        self.id = id
        self.text = text
        self.isUser = isUser
    }
}
