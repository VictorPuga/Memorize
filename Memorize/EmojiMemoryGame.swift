//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Víctor Manuel Puga Ruiz on 31/01/21.
//

import SwiftUI

class EmojiMemoryGame {
  private var game: MemoryGame<String> = createMemoryGame()
    
  
  private static func createMemoryGame() -> MemoryGame<String> {
    let emojis = ["😀", "👻", "🐢"]
    return MemoryGame<String>(numberOfPairsOfCards: emojis.count) { emojis[$0] }
  }
  
  // MARK: - Access to the model
  
  var cards: [MemoryGame<String>.Card] {
    game.cards
  }
  
  // MARK: - Intents
  
  func choose(card: MemoryGame<String>.Card) {
    game.choose(card: card)
  }
}
