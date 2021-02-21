//
//  Theme.swift
//  Memorize
//
//  Created by Víctor Manuel Puga Ruiz on 15/02/21.
//

import SwiftUI

struct Theme: Identifiable {
  let id = UUID()
  
  let name: String
  let emojis: [String]
  let pairs: Pairs
  let color: Color
}

enum Pairs {
  case random
  case fixed(Int)
}

// MARK: - Predefined themes
extension Theme {
  static let halloween = Theme(
    name: "Halloween",
    emojis: ["👻", "😈", "🎃", "👾", "👽", "🤖", "💩", "💀", "🤡"],
    pairs: .random,
    color: .orange
  )
  
  static let smileys = Theme(
    name: "Smileys",
    emojis: ["😀", "😆", "😅", "🤣", "🙃", "😛", "😎", "🤓", "🤨"],
    pairs: .fixed(6),
    color: .yellow
  )
  
  static let animals = Theme(
    name: "Animals",
    emojis: ["🐶", "🐱", "🐷", "🦁", "🐢", "🐼", "🐤", "🐍", "🐙"],
    pairs: .random,
    color: .blue
  )
  
  static let theme4 = Theme(
    name: "Theme 4",
    emojis: (0..<8).map { _ in String.randomEmoji },
    pairs: .random, color: .red
  )
  
  static let theme5 = Theme(
    name: "Theme 5",
    emojis: (0..<8).map { _ in String.randomEmoji },
    pairs: .random, color: .pink
  )
  
  static let theme6 = Theme(
    name: "Theme 6",
    emojis: (0..<8).map { _ in String.randomEmoji },
    pairs: .random, color: .green
  )
  
  // MARK: All
  static let all: [Theme] = [
    .halloween,
    .smileys,
    .animals,
    .theme4,
    .theme5,
    .theme6,
  ]
}
