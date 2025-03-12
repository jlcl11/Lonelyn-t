//
//  ChatView.swift
//  Lonelyn't
//
//  Created by José Luis Corral López on 12/3/25.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @FocusState private var isInputActive: Bool  // Para manejar el teclado

    var body: some View {
        ZStack {
            // Fondo Animado con Figuras en Movimiento
            AnimatedBackground()
            
            // Capa "glassy" con blur
            BlurView()
            
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(viewModel.messages) { message in
                                messageView(message)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                            }
                            
                            if viewModel.isTyping {
                                typingIndicator()
                                    .transition(.opacity)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                    .onChange(of: viewModel.messages.count) { _ in
                        if let lastMessage = viewModel.messages.last {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                
                inputBar()
            }
            .background(Color(UIColor.systemGroupedBackground).opacity(0.2))
            .animation(.easeInOut, value: viewModel.messages.count)
            
            // Empty Placeholder (se muestra si no hay mensajes)
            if viewModel.messages.isEmpty {
                emptyChatPlaceholder()
                    .allowsHitTesting(false) // Evita que bloquee interacciones con el TextField
            }
        }
        .onTapGesture {
            isInputActive = false // Oculta el teclado al tocar fuera del campo de texto
        }
    }
    
    private func emptyChatPlaceholder() -> some View {
        VStack {
            Image(systemName: "bubble.left.and.bubble.right.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray.opacity(0.5))
            
            Text("Start a conversation")
                .font(.headline)
                .foregroundColor(.gray.opacity(0.7))
                .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Ocupa todo el espacio
        .background(Color.clear) // Fondo transparente
    }

    private func messageView(_ message: ChatMessage) -> some View {
        HStack {
            if message.isUser {
                Spacer()
                Text(message.text)
                    .padding(12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .frame(maxWidth: 250, alignment: .trailing)
                    .padding(.trailing, 10)
            } else {
                Text(message.text)
                    .padding(12)
                    .background(Color(UIColor.secondarySystemBackground))
                    .foregroundColor(.primary)
                    .font(.system(size: 16))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .frame(maxWidth: 250, alignment: .leading)
                    .padding(.leading, 10)
                Spacer()
            }
        }
        .padding(.vertical, 4)
    }

    private func typingIndicator() -> some View {
        HStack {
            Text("AI is typing...")
                .italic()
                .foregroundColor(.gray)
                .font(.system(size: 14))
            Spacer()
        }
        .padding(.horizontal, 16)
    }

    private func inputBar() -> some View {
        HStack {
            TextField("Type a message...", text: $viewModel.inputText)
                .padding(12)
                .background(Color(UIColor.tertiarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .font(.system(size: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .focused($isInputActive)  // Enfoca el campo de texto

            if isInputActive {  // Solo se muestra cuando el teclado está activo
                withAnimation(.easeInOut(duration: 0.3)) {
                    Button(action: {
                        isInputActive = false // Oculta el teclado
                    }) {
                        Image(systemName: "keyboard.chevron.compact.down")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                            .padding(10)
                    }
                }
            }
            
            Button(action: viewModel.sendMessage) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding()
                    .background(viewModel.inputText.isEmpty ? Color.gray : Color.blue)
                    .clipShape(Circle())
            }
            .disabled(viewModel.inputText.isEmpty)
        }
        .padding()
    }
}

// 🎨 Fondo animado con figuras en movimiento
struct AnimatedBackground: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            ForEach(0..<5, id: \.self) { index in
                Circle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.6), Color.purple.opacity(0.4)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: CGFloat.random(in: 150...300), height: CGFloat.random(in: 150...300))
                    .position(x: CGFloat.random(in: 0...UIScreen.main.bounds.width), y: CGFloat.random(in: 0...UIScreen.main.bounds.height))
                    .blur(radius: 50)
                    .opacity(0.8)
                    .offset(x: animate ? CGFloat.random(in: -100...100) : 0,
                            y: animate ? CGFloat.random(in: -100...100) : 0)
                    .animation(Animation.easeInOut(duration: 6).repeatForever(autoreverses: true))
            }
        }
        .onAppear {
            animate.toggle()
        }
    }
}

// 🧊 Capa de desenfoque tipo "glassy"
struct BlurView: View {
    var body: some View {
        VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
            .ignoresSafeArea()
    }
}

// 📌 Componente para el efecto "glassmorphism"
struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

#Preview {
    ChatView()
}
