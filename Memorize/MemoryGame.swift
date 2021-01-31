//
//  MemoryGame.swift
//  Memorize
//
//  Created by Víctor Manuel Puga Ruiz on 31/01/21.
//

import Foundation

struct MemoryGame<CardContent> {
  var cards: [Card]
  
  init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
    cards = []
    for pairIndex in 0..<numberOfPairsOfCards {
      let content = cardContentFactory(pairIndex)
      cards.append(Card(id: pairIndex * 2, content: content))
      cards.append(Card(id: pairIndex * 2 + 1, content: content))
    }
    cards.shuffle()
  }
  
  func choose(card: Card) {
    print("chose: \(card)")
  }
  
  struct Card: Identifiable {
    var id: Int
    var isFaceUp: Bool = true
    var isMatched: Bool = false
    var content: CardContent
  }
}
