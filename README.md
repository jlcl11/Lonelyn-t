<p align="center">
  <img width="1500" alt="Lonelyn't" src="https://github.com/user-attachments/assets/a663ed3e-a47b-4689-965b-63181aeb7e5d" />
</p>

<h1 align="center">
  <br>
  Lonelyn't 🗨️✨
  <br>
</h1>

<h3 align="center">An AI chat companion with glassmorphism, haptics and a soul.</h3>

<p align="center">
  <strong>SwiftUI</strong> &nbsp;·&nbsp; <strong>HuggingFace BlenderBot</strong> &nbsp;·&nbsp; <strong>Text-to-Speech</strong> &nbsp;·&nbsp; <strong>Glassmorphism UI</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/iOS_15%2B-000000?style=for-the-badge&logo=apple&logoColor=white" alt="iOS 15+">
  <img src="https://img.shields.io/badge/Swift-F05138?style=for-the-badge&logo=swift&logoColor=white" alt="Swift">
  <img src="https://img.shields.io/badge/SwiftUI-007AFF?style=for-the-badge&logo=swift&logoColor=white" alt="SwiftUI">
  <img src="https://img.shields.io/badge/HuggingFace-FFD21E?style=for-the-badge&logo=huggingface&logoColor=black" alt="HuggingFace">
  <img src="https://img.shields.io/badge/AVSpeechSynth-30D158?style=for-the-badge&logo=apple&logoColor=white" alt="AVSpeech">
</p>

---

## What is Lonelyn't

Lonelyn't is a SwiftUI chat experience that wraps an AI conversational model behind a layered, animated, glass-and-mesh UI. It explores how to make a single-purpose chat feel premium: motion, depth, micro-interactions, sound — without losing focus on the conversation itself.

Replies come from HuggingFace's BlenderBot-400M. Messages can be copied, shared, replied to, deleted or read out loud with the system speech synthesiser.

---

## Features

| | |
|---|---|
| **AI replies** | Conversations powered by HuggingFace's BlenderBot-400M via REST. |
| **Glass UI** | Animated mesh background, blur layers, semi-transparent bubbles. |
| **Typing indicator** | Live indicator while the model generates a reply. |
| **Message actions** | Long-press for context menu: copy, delete, share, listen. |
| **Speak it** | One-tap text-to-speech with `AVSpeechSynthesizer`. |
| **Reply threading** | Reply to a specific message with formatted preview. |
| **Polish** | Haptic feedback, auto-scroll to latest message, smooth springs. |

---

## Architecture

```
Lonelyn't/
  View/
    ContentView.swift         ChatView surface — message list, input, glass background
  ViewModel/
    ChatViewModel.swift       Chat state, AI reply pipeline, speech, haptics
  Model/
    ChatMessage.swift         Message model with reply metadata
    ChatService.swift         HuggingFace REST integration
```

---

## Quick Start

**Requirements:** Xcode 14+ · iOS 15+ · Internet connection · Free HuggingFace API token

```bash
git clone https://github.com/jlcl11/Lonelyn-t.git
cd Lonelyn-t
open Lonelynt.xcodeproj
```

Drop your HuggingFace token into `ChatService.swift`:

```swift
private static let apiKey = "Bearer YOUR_TOKEN_HERE"
```

Get a free token at [huggingface.co](https://huggingface.co) → Account Settings → Access Tokens.

---

## Tech Stack

| Technology | Role |
|---|---|
| **SwiftUI** | Declarative UI with custom transitions |
| **MVVM** | Chat state separated from view layer |
| **URLSession + async/await** | HuggingFace REST client |
| **AVFoundation** | `AVSpeechSynthesizer` for text-to-speech |
| **UIKit haptics** | `UIImpactFeedbackGenerator` for tactile feedback on actions |
| **Glass background** | Animated background + blur effect inside `ContentView` |

---

<p align="center">
  Built by <a href="https://github.com/jlcl11">Jose Luis Corral Lopez</a> · A portfolio look at SwiftUI motion + AI
</p>
