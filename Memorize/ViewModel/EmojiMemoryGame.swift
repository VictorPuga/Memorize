//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Víctor Manuel Puga Ruiz on 31/01/21.
//

import SwiftUI

// MARK: ViewModel

class EmojiMemoryGame: ObservableObject {
  @Published private var game: MemoryGame<String> = createMemoryGame(with: .halloween)
  
  @Published private(set) var themes: [Theme] = Theme.all
  
  @Published private var themeIndex: Int = 0
  
  var theme: Theme { themes[themeIndex] }

  private static func createMemoryGame(with theme: Theme) -> MemoryGame<String> {
    var emojis = theme.emojis.shuffled()
  
    var pairs: Int?
    switch theme.pairs {
      case .random:
        pairs = Int.random(in: 2...5)
      case .fixed(let num):
        pairs = num
    }
  
    emojis = Array(emojis.prefix(pairs!))
    return MemoryGame<String>(numberOfPairsOfCards: emojis.count) { emojis[$0] }
  }
  
  // MARK: - Access to the model
  
  var cards: [MemoryGame<String>.Card] { game.cards }
  
  var points: Int { game.points }
  
  // MARK: - Intents
  
  func startGame(with index: Int) {
    themeIndex = index
    resetGame()
  }
  
  func resetGame() {
    game = Self.createMemoryGame(with: theme)
  }
  
  func choose(_ card: MemoryGame<String>.Card) {
    game.choose(card)
  }
  
  func addTheme(_ theme: Theme) {
    themes.append(theme)
  }
}

