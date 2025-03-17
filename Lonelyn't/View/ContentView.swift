//
//  ChatView.swift
//  Lonelyn't
//
//  Created by José Luis Corral López on 12/3/25.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @FocusState private var isInputActive: Bool  // Manejo del teclado

    var body: some View {
        ZStack {
            AnimatedBackground()
            BlurView()
            
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(viewModel.messages) { message in
                                messageView(message)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                                    .id(message.id)
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
                        DispatchQueue.main.async {
                            if let lastMessage = viewModel.messages.last {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }

                inputBar()
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [
                    Color.black.opacity(0.05),
                    Color.black.opacity(0.2)
                ]), startPoint: .top, endPoint: .bottom)
            )
            .animation(.easeInOut, value: viewModel.messages.count)

            if viewModel.messages.isEmpty {
                emptyChatPlaceholder()
                    .allowsHitTesting(false)
            }
        }
        .onTapGesture {
            isInputActive = false
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
    }

    private func messageView(_ message: ChatMessage) -> some View {
        HStack {
            if message.isUser {
                Spacer()
                Text(message.text)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue)
                    )
                    .foregroundColor(.white)
                    .frame(maxWidth: 250, alignment: .trailing)
                    .padding(.trailing, 10)
                    .accessibilityLabel("You: \(message.text)")
            } else {
                Text(message.text)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(UIColor.secondarySystemBackground))
                    )
                    .foregroundColor(.primary)
                    .frame(maxWidth: 250, alignment: .leading)
                    .padding(.leading, 10)
                    .accessibilityLabel("AI: \(message.text)")
                Spacer()
            }
        }
        .padding(.vertical, 4)
    }

    private func typingIndicator() -> some View {
        HStack {
            Circle().frame(width: 8, height: 8).foregroundColor(.gray).opacity(0.3)
                .animation(Animation.easeInOut(duration: 0.6).repeatForever(), value: viewModel.isTyping)
            Circle().frame(width: 8, height: 8).foregroundColor(.gray).opacity(0.6)
                .animation(Animation.easeInOut(duration: 0.6).repeatForever().delay(0.2), value: viewModel.isTyping)
            Circle().frame(width: 8, height: 8).foregroundColor(.gray).opacity(1)
                .animation(Animation.easeInOut(duration: 0.6).repeatForever().delay(0.4), value: viewModel.isTyping)
            
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
                .focused($isInputActive)
                .accessibilityLabel("Message input field")

            Button(action: viewModel.sendMessage) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding()
                    .background(viewModel.inputText.isEmpty ? Color(UIColor.systemGray4) : Color.blue)
                    .clipShape(Circle())
                    .scaleEffect(viewModel.inputText.isEmpty ? 0.9 : 1.0) // Animación sutil
            }
            .disabled(viewModel.inputText.isEmpty)
            .animation(.spring(), value: viewModel.inputText)
        }
        .padding()
        .animation(.easeInOut(duration: 0.3), value: isInputActive)
    }
}
struct AnimatedBackground: View {
    @State private var circles: [CircleData] = (0..<5).map { _ in CircleData() }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(circles.indices, id: \.self) { index in
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.6), Color.purple.opacity(0.4)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: circles[index].size, height: circles[index].size)
                        .blur(radius: 50)
                        .opacity(circles[index].opacity)
                        .position(circles[index].position)
                        .onAppear {
                            moveCircle(index: index, geometry: geometry)
                        }
                }
            }
            .ignoresSafeArea()
        }
    }

    // 📌 Modelo para cada círculo
    struct CircleData {
        var position: CGPoint = .zero
        var size: CGFloat = CGFloat.random(in: 150...300)
        var opacity: Double = Double.random(in: 0.5...0.9)
    }

    // 🔄 Mueve cada círculo de forma independiente
    private func moveCircle(index: Int, geometry: GeometryProxy) {
        let newX = CGFloat.random(in: 0...geometry.size.width)
        let newY = CGFloat.random(in: 0...geometry.size.height)

        withAnimation(Animation.easeInOut(duration: Double.random(in: 4...8)).repeatForever(autoreverses: true)) {
            circles[index].position = CGPoint(x: newX, y: newY)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 4...8)) {
            moveCircle(index: index, geometry: geometry)
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
