//
//  Array.swift
//  EmojiArt
//
//  Created by Víctor Manuel Puga Ruiz on 15/03/21.
//

import Foundation

extension Array where Element: Identifiable {
  mutating func remove(matching element: Element) {
    if let index = firstIndex(matching: element) {
      self.remove(at: index)
    }
  }
}

