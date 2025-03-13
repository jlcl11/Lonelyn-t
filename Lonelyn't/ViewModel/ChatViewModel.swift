//
//  ChatViewModel.swift
//  Lonelyn't
//
//  Created by José Luis Corral López on 12/3/25.
//

import SwiftUI
import AVFoundation

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isTyping: Bool = false
    @Published var replyingTo: ChatMessage? = nil  // ✅ Para responder mensajes

    private let speechSynthesizer = AVSpeechSynthesizer() // 🔹 Mantener una instancia en memoria
    
    // 📌 Enviar un mensaje
    func sendMessage() {
        guard !inputText.isEmpty else { return }

        let userMessage = ChatMessage(id: UUID(), text: inputText, isUser: true)
        messages.append(userMessage)

        let currentText = inputText
        inputText = ""
        
        isTyping = true

        ChatService.getAIResponse(for: currentText) { response in
            DispatchQueue.main.async {
                self.isTyping = false
                guard let reply = response else {
                    self.messages.append(ChatMessage(id: UUID(), text: "⚠️ No response received. Please try again.", isUser: false))
                    return
                }
                self.messages.append(ChatMessage(id: UUID(), text: reply, isUser: false))
            }
        }
    }

    // 📌 Copiar mensaje al portapapeles con feedback háptico
    func copyMessage(_ message: ChatMessage) {
        UIPasteboard.general.string = message.text
        DispatchQueue.main.async {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }

    // 📌 Eliminar un mensaje con opción de "Deshacer"
    func deleteMessage(_ message: ChatMessage) {
        withAnimation {
            messages.removeAll { $0.id == message.id }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showUndoDeleteAlert(for: message)
        }
    }

    private func showUndoDeleteAlert(for message: ChatMessage) {
        let alert = UIAlertController(title: "Message Deleted", message: "Undo?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Undo", style: .default) { _ in
            self.messages.append(message)
        })
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(alert, animated: true)
        }
    }

    // 📌 Editar un mensaje (sin eliminarlo inmediatamente)
    func editMessage(_ message: ChatMessage) {
        if let index = messages.firstIndex(where: { $0.id == message.id }) {
            let originalMessage = messages[index]
            
            inputText = messages[index].text
            messages.remove(at: index)

            DispatchQueue.main.asyncAfter(deadline: .now() + 10) { // Tiempo para cancelar la edición
                if self.inputText.isEmpty {
                    self.messages.insert(originalMessage, at: index)
                }
            }
        }
    }

    // 📌 Responder a un mensaje
    func replyToMessage(_ message: ChatMessage) {
        replyingTo = message
        inputText = "↩️ \(message.text) \n"
    }

    // 📌 Leer un mensaje en voz alta (con opción de detener)
    func speakMessage(_ message: ChatMessage) {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        let utterance = AVSpeechUtterance(string: message.text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(utterance)
    }

    // 📌 Compartir un mensaje con comprobación de UI disponible
    func shareMessage(_ text: String) {
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else {
            print("⚠️ No root view controller available.")
            return
        }
        
        rootVC.present(activityVC, animated: true, completion: nil)
    }
}
