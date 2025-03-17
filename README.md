# Lonelyn't 🗨️✨  

### A Smart and Aesthetic Chat Application  

![iPhone 16 Pro](https://github.com/user-attachments/assets/a663ed3e-a47b-4689-965b-63181aeb7e5d)

![SwiftUI](https://img.shields.io/badge/SwiftUI-Framework-orange)  
![iOS](https://img.shields.io/badge/iOS-15%2B-blue)  
![Xcode](https://img.shields.io/badge/Xcode-14%2B-lightgrey)  

## 📌 Description  

**Lonelyn't** is a **SwiftUI-powered** chat application that provides a **smooth and engaging experience** with an animated background, glassmorphism effects, and **AI-generated responses**.  

The goal is to create an intuitive, visually appealing, and functional chat environment with features like AI-powered responses, text-to-speech, message editing, contextual menus, and more.  

---

## ✨ Features  

✔️ **Modern & animated UI** with moving backgrounds  
✔️ **AI-powered responses** using BlenderBot  
✔️ **Glassmorphism effect** for a stylish look  
✔️ **Real-time typing indicator**  
✔️ **Copy, delete, share, and listen to messages**  
✔️ **Context menu for message actions**  
✔️ **Auto-scroll to the latest message**  
✔️ **Reply to messages with formatted text**  
✔️ **Haptic feedback and smooth animations**  

---

## 🛠 Installation  

### 1️⃣ Requirements  

- Xcode 14+  
- iOS 15+  
- Internet connection (for AI responses)  

### 2️⃣ Clone the repository  

```bash
git clone https://github.com/your-username/Lonelynt.git
cd Lonelynt
```
---

## 🚀 Usage  

1. **Start a conversation**: Type a message and hit send.  
2. **Interact with messages**: Long-press a message to copy, delete, or share it.  
3. **AI response**: The app will generate a reply automatically.  
4. **Enjoy smooth animations**: Experience a beautifully designed interface.  

---

## ⚠️ Important Note: Update the API Key  

The app uses Hugging Face's **BlenderBot-400M** model for AI responses.  
You **must replace the API key** in `ChatService.swift` with your own.  

### How to get an API key?  

1. **Sign up on Hugging Face**: [https://huggingface.co](https://huggingface.co)  
2. **Generate an API key** from your account settings.  
3. **Replace the API key** in the `ChatService.swift` file:  

```swift
private static let apiKey = "Bearer YOUR_API_KEY_HERE"
```

## 🏗️ Project Structure  

```
Lonelynt/
│── Views/
│   ├── ChatView.swift         # Main chat interface
│   ├── AnimatedBackground.swift  # Dynamic animated backgrounds
│   ├── BlurView.swift         # Glassmorphism blur effect
│── ViewModels/
│   ├── ChatViewModel.swift    # Handles chat logic
│── Models/
│   ├── ChatMessage.swift      # Message model
│── Services/
│   ├── ChatService.swift      # AI response integration
│── Assets/
│   ├── Icon.png               # App icon
│── README.md                  # Documentation
│── Lonelynt.xcodeproj         # Xcode project
```

