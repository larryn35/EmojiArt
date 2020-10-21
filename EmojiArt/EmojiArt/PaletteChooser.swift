//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Larry Nguyen on 10/20/20.
//

import SwiftUI

struct PaletteChooser: View {
    @Binding var chosenPalette: String
    @ObservedObject var document: EmojiArtDocument
    
    var body: some View {
        HStack {
            Stepper(
                onIncrement: {
                    chosenPalette = document.palette(after: chosenPalette)
                },
                onDecrement: {
                    chosenPalette = document.palette(before: chosenPalette)
                },
                label: {
                    EmptyView()
                })
            Text(document.paletteNames[chosenPalette] ?? "")
        }
        .fixedSize(horizontal: true, vertical: false) // size itself to fit and not use any extra space
    }
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(chosenPalette: Binding.constant(""), document: EmojiArtDocument())
    }
}
