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
    @State private var paletteName: String = ""
    @State private var emojisToAdd: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Palette Editor")
                .font(.headline)
                .padding()
            Divider()
            Form {
                Section(header: Text("Palette Name")) {
                    // Rename palette
                    TextField("Palette Name", text: $paletteName, onEditingChanged: { began in
                        if !began { // rename palette when editing ends
                            document.renamePalette(chosenPalette, to: paletteName)
                        }
                    })
                    //                    .padding() - no longer needed, form takes care of padding
                    
                    
                    // Add emojis
                    TextField("Add Emoji", text: $emojisToAdd, onEditingChanged: { began in
                        if !began { // rename palette when editing ends
                            chosenPalette = document.addEmoji(emojisToAdd, toPalette: chosenPalette)
                            emojisToAdd = ""
                        }
                    })
                    //                .padding()
                }
                
                // Remove Emoji
                Section(header: Text("Remove Emoji")) {
                    VStack {
                        ForEach(chosenPalette.map { String($0) }, id: \.self) { emoji in
                            Text(emoji)
                                .onTapGesture {
                                    chosenPalette = document.removeEmoji(emoji, fromPalette: chosenPalette)
                                }
                        }
                    }
                }
            }
            //            Spacer() - no longer needed, forms take up entire space given to it
        }
        .onAppear { paletteName = document.paletteNames[chosenPalette] ?? "" }
    }
}





struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(chosenPalette: Binding.constant(""), document: EmojiArtDocument())
    }
}
