//
//  TranslatorAppApp.swift
//  TranslatorApp
//
//  Created by Alexander Petrenko on 27.08.2024.
//

import SwiftUI

@main
struct TranslatorAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: TranslatorViewModel(translationService: OpenAITranslationService()))
        }
    }
}
