//
//  TranslationService.swift
//  TranslatorApp
//
//  Created by Alexander Petrenko on 27.08.2024.
//

import Foundation

protocol TranslationService {
    func translate(text: String, from sourceLanguage: String, to targetLanguage: String, completion: @escaping (String?) -> Void)
}

class OpenAITranslationService: TranslationService {
    func translate(text: String, from sourceLanguage: String, to targetLanguage: String, completion: @escaping (String?) -> Void) {
        let tranlatedText = "Translated text: \(text)"
        completion(tranlatedText)
    }
}

class TranslatorViewModel: ObservableObject {
    private let translationService: TranslationService
    
    init(translationService: TranslationService) {
        self.translationService = translationService
    }
    
    func performTranslation(inputText: String, from sourceLanguage: String, to targetLanguage: String, completion: @escaping (String) -> Void) {
        translationService.translate(text: inputText, from: sourceLanguage, to: targetLanguage) { translated in completion(translated ?? "")
        }
    }
   
}
