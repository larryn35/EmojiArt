//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Larry Nguyen on 10/19/20.
//

// Model

import Foundation

struct EmojiArt {
    var backgroundURL: URL?
    var emojis = [Emoji]()
    
    struct Emoji: Identifiable {
        var id: Int
        let text: String
        var x: Int
        var y: Int
        var size: Int
        
        // restricts emoji creating to func addEmoji, preventing someone from creating an emoji with their own ID and adding it to emojis
        // still let people adjust position and size - which wouldn't be allowed with private(set) var emojis
        fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
    
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ text: String, x: Int, y: Int, size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(text: text, x: x, y: y, size: size, id: uniqueEmojiId))
    }
}
