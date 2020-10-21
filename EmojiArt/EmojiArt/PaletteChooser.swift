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
    @State private var showPaletteEditor = false
    
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
            
            // edit emojis for palette
            Image(systemName: "keyboard").imageScale(.large)
                .onTapGesture {
                    showPaletteEditor = true
                }
                .popover(isPresented: $showPaletteEditor) {
                    PaletteEditor(chosenPalette: $chosenPalette)
                        .environmentObject(document)
                        .frame(minWidth: 300, minHeight: 500)
                }
        }
        .fixedSize(horizontal: true, vertical: false) // size itself to fit and not use any extra space
    }
}

struct PaletteEditor: View {
    // anytime we want to present something in a separate view, such as a popover, viewmodel should be passed using environmentobject
    @EnvironmentObject var document: EmojiArtDocument
    @Binding var chosenPalette: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Palette Editor")
                .font(.headline)
                .padding()
            Divider()
            Text(document.paletteNames[chosenPalette] ?? "")
                .padding()
            Spacer()
        }
    }
}





struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(chosenPalette: Binding.constant(""), document: EmojiArtDocument())
    }
}
