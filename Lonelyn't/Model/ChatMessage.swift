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
}
