//
//  ContentView.swift
//  EmojiArt
//
//  Created by Larry Nguyen on 10/19/20.
//

// View

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(EmojiArtDocument.palette.map { String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .font(Font.system(size: defaultEmojiSize))
                            .onDrag { return NSItemProvider(object: emoji as NSString)}
                    }
                }
            }
            .padding(.horizontal)
            
            GeometryReader { geometry in
                Rectangle()
                    .foregroundColor(.white)
                    .edgesIgnoringSafeArea([.horizontal, .bottom])
                    .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                        // for dropped emoji
                        var location = geometry.convert(location, from: .global)
                        // location is in iOS coordination - (0,0) is in upper left
                        location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                        return self.drop(providers: providers, at: location)
                    }
                    .overlay(
                        Group {
                            if self.document.backgroundImage != nil {
                                Image(uiImage: self.document.backgroundImage!)
                            }
                        }
                )
            }
        }
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            print("dropped \(url)")
            self.document.setBackgroundURL(url)
        }
        // emoji dropped
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                self.document.addEmoji(string, at: location, size: self.defaultEmojiSize)
            }
        }
        return found
    }
    
    private let defaultEmojiSize: CGFloat = 40
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
