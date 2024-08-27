//
//  ContentView.swift
//  TranslatorApp
//
//  Created by Alexander Petrenko on 27.08.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: TranslatorViewModel
    @State private var inputText: String = ""
    @State private var translateText: String = ""
    @State private var sourceLanguage: String = "en"
    @State private var targetLanguage: String = "ru"
    
    let languages: [String] = ["en", "ru", "de", "fr", "es", "it", "pt", "ar", "ja", "ko", "zh"]
    
    var body: some View {
        HStack(spacing: 20) {
            VStack {
                Picker("From", selection: $sourceLanguage) {
                    ForEach(languages, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                
                TextField("Enter Text", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            .frame(maxWidth: .infinity)
            
            VStack {
                Picker("To", selection: $targetLanguage) {
                    ForEach(languages, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                
                TextField("Translation", text: $translateText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .disabled(true)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .onChange(of: inputText) { newText in
            viewModel.performTranslation(inputText: newText, from: sourceLanguage, to: targetLanguage) { translated in
                translateText = translated
            }
        }
    }
}

//#Preview {
//    ContentView()
//}
