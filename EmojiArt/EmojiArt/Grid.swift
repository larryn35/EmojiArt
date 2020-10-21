//
//  Grid.swift
//  CardMatch
//
//  Created by Larry Nguyen on 10/17/20.
//

import SwiftUI

extension Grid where Item: Identifiable, ID == Item.ID {
    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.init(items, id: \Item.id, viewForItem: viewForItem)
    }
}

struct Grid<Item, ID, ItemView>: View where ID: Hashable, ItemView: View {
    // can be private due to initializer that set the vars, rather than someone initializing them directly
    private var items: [Item]
    private var id: KeyPath<Item,ID>
    private var viewForItem: (Item) -> ItemView
    
    init(_ items: [Item], id: KeyPath<Item, ID>, viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.id = id
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            ForEach(items, id: id) { item in
                let gridLayout = GridLayout(itemCount: items.count, in: geometry.size)
                let index = items.firstIndex(where: { item[keyPath: id] == $0[keyPath: id] } )
                
                Group { // ViewBuilder - allows if/thens, similar to ZStack but doesn't do anything to the views
                    if index != nil { // not really needed since index should never be nil
                        viewForItem(item)
                            .frame(width: gridLayout.itemSize.width, height: gridLayout.itemSize.height)
                            .position(gridLayout.location(ofItemAt: index!))
                    }
                }
            }
        }
    }
}
