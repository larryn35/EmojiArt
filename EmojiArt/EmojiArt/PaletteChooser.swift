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
                    PaletteEditor(chosenPalette: $chosenPalette, isShowing: $showPaletteEditor)
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
    @Binding var isShowing: Bool // same as showPaletteEditor in palettechooser above
    @State private var paletteName: String = ""
    @State private var emojisToAdd: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Palette Editor")
                    .font(.headline)
                    .padding()
                HStack {
                    Spacer()
                    Button(action: {
                        isShowing = false
                    }, label: { Text("Done") })
                        .padding()
                }
            }
            Divider()
            Form {
                Section(header: Text("Palette Name")) {
                    // Rename palette
                    TextField("Palette Name", text: $paletteName, onEditingChanged: { began in
                        if !began { // rename palette when editing ends
                            document.renamePalette(chosenPalette, to: paletteName)
                        }
                    })
                                        
                    // Add emojis
                    TextField("Add Emoji", text: $emojisToAdd, onEditingChanged: { began in
                        if !began { // rename palette when editing ends
                            chosenPalette = document.addEmoji(emojisToAdd, toPalette: chosenPalette)
                            emojisToAdd = ""
                        }
                    })
                }
                
                // Remove Emoji
                Section(header: Text("Remove Emoji")) {
                    Grid(chosenPalette.map { String($0) }, id: \.self) { emoji in
                            Text(emoji)
                                .font(.system(size: fontSize))
                                .onTapGesture {
                                    chosenPalette = document.removeEmoji(emoji, fromPalette: chosenPalette)
                                }
                        }
                    .frame(height: height)
                }
            }
        }
        .onAppear { paletteName = document.paletteNames[chosenPalette] ?? "" }
    }
    
    //MARK: - Drawing Constants
    
    var height: CGFloat {
        CGFloat((chosenPalette.count - 1) / 6) * 70 + 70
    }
    
    let fontSize: CGFloat = 40
}





struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(chosenPalette: Binding.constant(""), document: EmojiArtDocument())
    }
}
