//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Larry Nguyen on 10/19/20.
//

// Model

import Foundation

struct EmojiArt: Codable {
    var backgroundURL: URL?
    var emojis = [Emoji]()
    
    struct Emoji: Identifiable, Codable {
        var id: Int
        let text: String
        var x: Int // offset from center
        var y: Int // offset from center
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
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init?(json: Data?) { // init? = failable initializer, returns nil if fail
        if json != nil, let newEmojiArt = try? JSONDecoder().decode(EmojiArt.self, from: json!) {
            self = newEmojiArt
        } else {
            return nil
        }
    }
    
    init() { } // restore init, which was lost when creating the init above
    
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ text: String, x: Int, y: Int, size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(text: text, x: x, y: y, size: size, id: uniqueEmojiId))
    }
}
