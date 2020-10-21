//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Larry Nguyen on 10/19/20.
//

// ViewModel

import SwiftUI
import Combine

class EmojiArtDocument: ObservableObject {
    
    static let palette: String = "🐶🐱🐭🐹🦊🐻🐼"
    
//    @Published private var emojiArt: EmojiArt = EmojiArt() {
//        didSet {
//            print("json = \(emojiArt.json?.utf8 ?? "nil")")
//        }
//    }
    
    // use projectedValue ($emojiArt) of published struct
    @Published private var emojiArt: EmojiArt
    
    private static let untitled = "EmojiArtDocument.untitled"
    
    // allows sink to live past execution of init
    private var autosaveCancellable: AnyCancellable? // AnyCancellable is a type-erased version for the sink contents
    
    init() {
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: EmojiArtDocument.untitled)) ?? EmojiArt()
        autosaveCancellable = $emojiArt.sink { emojiArt in
            print("\(emojiArt.json?.utf8 ?? "nil")")
            UserDefaults.standard.set(emojiArt.json, forKey: EmojiArtDocument.untitled)
        }
        fetchBackgroundImageData()
    }
    
    // want background image to automatically resize upon dropping, can use $backgroundImage in view to trigger
    @Published private(set) var backgroundImage: UIImage?
    
    var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
    
    //MARK: - Intent(s)
    // View can call these, since it can't directly acess emojiArt
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }
    
    // make gettable for isLoading var
    var backgroundURL: URL? {
        get {
            emojiArt.backgroundURL
        }
        set {
            emojiArt.backgroundURL = newValue?.imageURL
            fetchBackgroundImageData()
        }
    }
    
    private func fetchBackgroundImageData() {
        backgroundImage = nil
        if let url = self.emojiArt.backgroundURL {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        // prevents older image from being loaded if user dropped new one in
                        if url == self.emojiArt.backgroundURL {
                            self.backgroundImage = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
}


// Avoids using Int in view, view model interprets data from the model
extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
