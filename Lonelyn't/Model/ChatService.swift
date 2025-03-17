//
//  ChatService.swift
//  Lonelyn't
//
//  Created by José Luis Corral López on 12/3/25.
//

import Foundation

class ChatService {
    private static let apiURL = "https://api-inference.huggingface.co/models/facebook/blenderbot-400M-distill"
    private static let apiKey = "Bearer YOUR_HF_TOKEN"  

    static func getAIResponse(for message: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: apiURL) else {
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")

        let body: [String: Any] = ["inputs": message]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                completion(nil)
                return
            }

            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]],
                   let firstResult = jsonArray.first,
                   let aiResponse = firstResult["generated_text"] as? String {
                    completion(aiResponse)
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }
}
