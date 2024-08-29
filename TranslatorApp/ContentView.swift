//
//  ContentView.swift
//  TranslatorApp
//
//  Created by Alexander Petrenko on 27.08.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: TranslatorViewModel

    
    //let languages = ["English", "Russian", "Spanish", "French", "German"]
    
    var body: some View {
        
        HStack(spacing: 20) {
            VStack {
                Picker("From", selection: $viewModel.sourceLanguage) {
                    ForEach(["auto", "en", "es", "fr", "de", "ru"], id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                
                TextEditor(text: $viewModel.inputText)
                    .frame(minHeight: 50, maxHeight: 100)
                    .padding()
            }
            .frame(maxWidth: .infinity)
            
            VStack {
                Picker("To", selection: $viewModel.targetLanguage) {
                    ForEach(["ru", "en", "es", "fr", "de"], id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                
                TextEditor(text: $viewModel.translateText)
                    .frame(minHeight: 50, maxHeight: 100)
                    .padding()
                
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
//        .onChange(of: viewModel.inputText) {val, _ in
//                        viewModel.performTranslation()
//                    }
//        .onChange(of: viewModel.sourceLanguage) {val, _ in
//            viewModel.performTranslation()
//        }
//        .onChange(of: viewModel.targetLanguage) {val, _ in
//            viewModel.performTranslation()
//        }
        
        Button("translate") {
            viewModel.performTranslation()
        }
        .padding()
        
        if let errorMessage = viewModel.errorMessages {
            VStack {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
       
    }
}

//#Preview {
//    ContentView()
//}
