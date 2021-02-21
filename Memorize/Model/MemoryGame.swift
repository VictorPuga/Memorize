//
//  MemoryGame.swift
//  Memorize
//
//  Created by Víctor Manuel Puga Ruiz on 31/01/21.
//

import Foundation

// MARK: Model

struct MemoryGame<CardContent> where CardContent: Equatable {
  private(set) var cards: [Card]
  var points: Int = 0
  
  private var selectedCardIndex: Int? {
    get { cards.indices.filter { cards[$0].isFaceUp }.only }
    set {
      for index in cards.indices {
        cards[index].isFaceUp = index == newValue
      }
    }
  }
  
  init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
    cards = []
    for pairIndex in 0..<numberOfPairsOfCards {
      let content = cardContentFactory(pairIndex)
      cards.append(Card(id: pairIndex * 2, content: content))
      cards.append(Card(id: pairIndex * 2 + 1, content: content))
    }
    cards.shuffle()
  }
  
  mutating func choose(_ card: Card) {
    if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
      if let previousSelectionIndex = selectedCardIndex {
        if cards[chosenIndex].content == cards[previousSelectionIndex].content {
          cards[chosenIndex].isMatched = true
          cards[previousSelectionIndex].isMatched = true
          points += 2
        }
        else { // Should this stop at 0?
          points -= 1
        }
        cards[chosenIndex].isFaceUp = true
      }
      else {
        selectedCardIndex = chosenIndex
      }
    }
  }
  
  struct Card: Identifiable {
    var id: Int
    var isFaceUp: Bool = false {
      didSet {
        if isFaceUp {
          startUsingBonusTime()
        }
        else {
          stopUsingBonusTime()
        }
      }
    }
    var isMatched: Bool = false {
      didSet {
        stopUsingBonusTime()
      }
    }
    var content: CardContent
    
    // MARK: - Bonus Time
    
    var bonusTimeLimit: TimeInterval = 6
    
    private var faceUpTime: TimeInterval {
      if let lastFaceUpDate = self.lastFaceUpDate {
        return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
      }
      else {
        return pastFaceUpTime
      }
    }
    
    var lastFaceUpDate: Date?
    
    var lastFaceUpTime: TimeInterval?
    
    var pastFaceUpTime: TimeInterval = 0
    
    var bonusTimeRemaining: TimeInterval {
      max(0, bonusTimeLimit - faceUpTime)
    }
    
    var bonusRemaining: Double {
      (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
    }
    
    var hasEarnedBonus: Bool {
      isMatched && bonusTimeRemaining > 0
    }
    
    var isConsumingBonusTime: Bool {
      isFaceUp && !isMatched && bonusTimeRemaining > 0
    }
    
    private mutating func startUsingBonusTime() {
      if isConsumingBonusTime, lastFaceUpTime == nil {
        lastFaceUpDate = Date()
      }
    }
    
    private mutating func stopUsingBonusTime() {
      pastFaceUpTime = faceUpTime
      self.lastFaceUpDate = nil
    }
  }
}
