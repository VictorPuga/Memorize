//
//  Set.swift
//  EmojiArt
//
//  Created by Víctor Manuel Puga Ruiz on 15/03/21.
//

import Foundation

extension Set where Element: Identifiable {
  mutating func toggle(matching element: Element) {
    if self.contains(matching: element) {
      self.remove(matching: element)
    } else {
      self.insert(element)
    }
  }
  
  mutating func remove(matching element: Element) {
    if let index = firstIndex(matching: element) {
      self.remove(at: index)
    }
  }
}
