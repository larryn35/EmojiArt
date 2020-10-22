//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Larry Nguyen on 10/19/20.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    let url: URL
    let store: EmojiArtDocumentStore

    init() {
        url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        store = EmojiArtDocumentStore(directory: url)
    }
    
//    let store = EmojiArtDocumentStore(named: "Emoji Art")
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentChooser()
                .environmentObject(store)
                .onAppear {
//                    store.addDocument()
//                    store.addDocument(named: "Hello World")
                }
        }
    }
}
