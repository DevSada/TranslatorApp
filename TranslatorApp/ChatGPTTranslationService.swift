//
//  ChatGPTTranslationService.swift
//  TranslatorApp
//
//  Created by Alexander Petrenko on 28.08.2024.
//

import Foundation

class ChatGPTTranslationService: TranslationService {
    
    private let apiKey = "my api key"
    
    func translate(text: String, from sourceLanguage: String, to targetLanguage: String, completion: @escaping (String?) -> Void) {
        let prompt = "Translate, please, the following text from \(sourceLanguage) to \(targetLanguage): \(text)"
        let apiURL = URL(string: "https://api.openai.com/v1/chat/completions")!
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "You are a translation engine"],
                ["role": "user", "content": prompt]
            ],
            "max_tokens": 100
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error as? URLError {
                switch error.code {
                case .notConnectedToInternet:
                    print("No internet connection.")
                case .timedOut:
                    print("Request timed out.")
                case .cannotFindHost, .cannotConnectToHost:
                    print("Cannot find or connect to host.")
                default:
                    print("Error: \(error.localizedDescription)")
                }
                completion(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: No response from server.")
                completion(nil)
                return
            }
            
            if httpResponse.statusCode == 429 {
                print("Error: Too many requests. Retrying in 5 seconds...")
                DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                    self.translate(text: text, from: sourceLanguage, to: targetLanguage, completion: completion)
                }
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                print("Error: Invalid response from server with status code \(httpResponse.statusCode).")
                completion(nil)
                return
            }
            
            
            guard let data = data else {
                print("Error: No data received.")
                completion(nil)
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let choices = json["choices"] as? [[String: Any]],
               let message = choices.first?["messages"] as? [String: Any],
               let content = message["content"] as? String {
                completion(content.trimmingCharacters(in: .whitespacesAndNewlines))
            } else {
                print("Error: Invalid response format.")
                completion(nil)
            }
            
        }
        
        task.resume()
    }
    
    
}
