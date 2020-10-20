//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Larry Nguyen on 10/19/20.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: EmojiArtDocument())
        }
    }
}
