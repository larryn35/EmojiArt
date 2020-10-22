//
//  EmojiArtDocumentChooser.swift
//  EmojiArt
//
//  Created by Larry Nguyen on 10/20/20.
//

import SwiftUI

struct EmojiArtDocumentChooser: View {
    @EnvironmentObject var store: EmojiArtDocumentStore
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.documents) { document in
                    NavigationLink(
                        destination: EmojiArtDocumentView(document: document)
                            .navigationBarTitle(store.name(for: document))
                    ) {
                        Text(self.store.name(for: document))
                    }
                }
            }
            .navigationBarTitle(self.store.name)
            .navigationBarItems(leading: Button(action: {
                store.addDocument()
            }, label: {
                Image(systemName: "plus").imageScale(.large)
            }), trailing: EditButton())
        }
    }
}

struct EmojiArtDocumentChooser_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentChooser()
    }
}
