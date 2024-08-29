//
//  TranslatorAppApp.swift
//  TranslatorApp
//
//  Created by Alexander Petrenko on 27.08.2024.
//

import SwiftUI

@main
struct TranslatorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: TranslatorViewModel(translationService: LibreTranslateTranslationService()))// ChatGPTTranslationService()))
        }
    }
}
