//
//  Grid.swift
//  Memorize
//
//  Created by Víctor Manuel Puga Ruiz on 15/02/21.
//

import SwiftUI

struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
  var items: [Item]
  var viewForItem: (Item) -> ItemView
  
  init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
    self.items = items
    self.viewForItem = viewForItem
  }
  
  // MARK: - Body
  var body: some View {
    GeometryReader { geometry in
      body(for: GridLayout(itemCount: items.count, in: geometry.size))
    }
  }
  
  func body(for layout: GridLayout) -> some View {
    ForEach(items) { item in
      body(for: item, in: layout)
    }
  }
  
  func body(for item: Item, in layout: GridLayout) -> some View {
    let index = items.firstIndex(matching: item)!
    
    return viewForItem(item)
      .frame(
        width: layout.itemSize.width,
        height: layout.itemSize.height
      )
      .position(layout.location(ofItemAt: index))
  }
}


// MARK: - Preview
struct Grid_Previews: PreviewProvider {
  static let items: [MemoryGame<String>.Card] = [
    .init(id: 0, content: "A"),
    .init(id: 1, content: "B"),
    .init(id: 2, content: "C"),
    .init(id: 3, content: "D")
  ]
  
  static var previews: some View {
    Grid(items) { item in
      VStack {
        Spacer()
        HStack {
          Spacer()
          Text(item.content)
          Spacer()
        }
        Spacer()
      }
      .background(Color.red)
      .padding(1)
      
    }
    .previewLayout(.sizeThatFits)
    .padding()
  }
}
