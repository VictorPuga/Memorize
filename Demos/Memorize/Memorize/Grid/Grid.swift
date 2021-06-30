//
//  Grid.swift
//  Memorize
//
//  Created by Víctor Manuel Puga Ruiz on 15/02/21.
//

import SwiftUI

extension Grid where Item: Identifiable, ID == Item.ID {
  init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
    self.init(items, id: \Item.id, viewForItem: viewForItem)
  }
}

struct Grid<Item, ID, ItemView>: View where ID: Hashable, ItemView: View {
  private var items: [Item]
  private var id: KeyPath<Item,ID>
  private var viewForItem: (Item) -> ItemView
  
  init(_ items: [Item], id: KeyPath<Item,ID>, viewForItem: @escaping (Item) -> ItemView) {
    self.items = items
    self.id = id
    self.viewForItem = viewForItem
  }
  
  var body: some View {
    GeometryReader { geometry in
      self.body(for: GridLayout(itemCount: self.items.count, in: geometry.size))
    }
  }
  
  private func body(for layout: GridLayout) -> some View {
    return ForEach(items, id: id) { item in
      self.body(for: item, in: layout)
    }
  }
  
  private func body(for item: Item, in layout: GridLayout) -> some View {
    let index = items.firstIndex(where: { item[keyPath: id] == $0[keyPath: id] } )
    return Group {
      if index != nil {
        viewForItem(item)
          .frame(width: layout.itemSize.width, height: layout.itemSize.height)
          .position(layout.location(ofItemAt: index!))
      }
    }
  }
}

// MARK: - Preview
// struct Grid_Previews: PreviewProvider {
//   static let items: [MemoryGame<String>.Card] = [
//     .init(id: 0, content: "A"),
//     .init(id: 1, content: "B"),
//     .init(id: 2, content: "C"),
//     .init(id: 3, content: "D")
//   ]
//   
//   static var previews: some View {
//     Grid(items) { item in
//       VStack {
//         Spacer()
//         HStack {
//           Spacer()
//           Text(item.content)
//           Spacer()
//         }
//         Spacer()
//       }
//       .background(Color.red)
//       .padding(1)
//       
//     }
//     .previewLayout(.sizeThatFits)
//     .padding()
//   }
// }
