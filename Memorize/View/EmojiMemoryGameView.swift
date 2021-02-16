//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Víctor Manuel Puga Ruiz on 31/01/21.
//

import SwiftUI

// MARK: View

struct EmojiMemoryGameView: View {
  @ObservedObject var viewModel: EmojiMemoryGame
  
  // MARK: - Body
  var body: some View {
    Grid(viewModel.cards) { card in
      CardView(card: card)
        .padding(5)
        .onTapGesture {
          viewModel.choose(card)
        }
    }
    .padding()
    .foregroundColor(.orange)
  }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
  }
}
