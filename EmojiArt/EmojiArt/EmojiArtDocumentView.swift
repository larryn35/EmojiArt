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
                    }
                }
            }
            .padding(.horizontal)
            
            Rectangle()
                .foregroundColor(.yellow)
                .edgesIgnoringSafeArea([.horizontal, .bottom])
        }
    }
    
    private let defaultEmojiSize: CGFloat = 40
}

// Not preferred - id: \.self is better access control
//extension String: Identifiable {
//    public var id: String { return self}
//}



//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
