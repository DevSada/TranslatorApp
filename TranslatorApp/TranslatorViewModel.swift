//
//  TranslatorViewModel.swift
//  TranslatorApp
//
//  Created by Alexander Petrenko on 28.08.2024.
//

import SwiftUI

class TranslatorViewModel: ObservableObject {
    private let translationService: TranslationService
    @Published  var inputText: String = ""
    @Published  var translateText: String = ""
    @Published var sourceLanguage: String = "auto"//"English"
    @Published  var targetLanguage: String = "ru"//"Russian"
    @Published var isTranslating: Bool = false
    @Published var errorMessages: String?
    
    init(translationService: TranslationService) {
        self.translationService = translationService
    }
    
    func performTranslation() {
        guard !inputText.isEmpty else {
            errorMessages = "Please enter text to translate"
            return
        }
        
        isTranslating = true
        errorMessages = nil
        
        translationService.translate(text: inputText, from: sourceLanguage, to: targetLanguage) { [weak self] translated in
            DispatchQueue.main.async {
                self?.isTranslating = false
                if let translated = translated {
                    self?.translateText = translated
                } else {
                    self?.errorMessages = "Translation failed. Please try again"
                }
            }
            
        }
    }
//
//    func performTranslation(inputText: String, from sourceLanguage: String, to targetLanguage: String, completion: @escaping (String) -> Void) {
//        translationService.translate(text: inputText, from: sourceLanguage, to: targetLanguage) { translated in completion(translated ?? "")
//        }
//    }
   
}

