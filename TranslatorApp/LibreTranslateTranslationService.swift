//
//  LibreTranslateTranslationService.swift
//  TranslatorApp
//
//  Created by Alexander Petrenko on 29.08.2024.
//

import Foundation

class LibreTranslateTranslationService: TranslationService {
    func translate(text: String, from sourceLanguage: String, to targetLanguage: String, completion: @escaping (String?) -> Void) {
        let apiURL = URL(string: "https://libretranslate.com/translate")!
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "q": text,
            "source": sourceLanguage == "auto" ? "" : sourceLanguage,
            "target": targetLanguage,
            "format": "text",
            "alternatives": 3,
            "api_key": ""
        ]
        print("sourceLanguage - \(sourceLanguage), targetLanguage - \(targetLanguage), text - \(text)")
        
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
                       let translatedText = json["translatedText"] as? String {
                        completion(translatedText)
                    } else {
                        print("Error: Failed to parse response.")
                        completion(nil)
                    }
                }
                
                task.resume()    }
}
