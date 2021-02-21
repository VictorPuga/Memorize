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
    VStack {
      HStack {
        Text("Points: ")
          .foregroundColor(.black)
        Text("\(viewModel.points)")
      }
      .font(.largeTitle)
      Grid(viewModel.cards) { card in
        CardView(card: card)
          .padding(5)
          .onTapGesture {
            withAnimation(.linear(duration: 0.75)) {
              viewModel.choose(card)
            }
          }
      }
      Button(action: {
        withAnimation(.easeInOut) {
          viewModel.resetGame()
        }
      }) {
        Text("Reset game")
      }
    }
    .padding()
    .foregroundColor(viewModel.theme.color)
    .navigationBarTitle(Text(viewModel.theme.name), displayMode: .inline)
  }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
  }
}
