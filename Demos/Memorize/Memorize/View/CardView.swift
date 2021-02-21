//
//  CardView.swift
//  Memorize
//
//  Created by Víctor Manuel Puga Ruiz on 15/02/21.
//

import SwiftUI

struct CardView: View {
  var card: MemoryGame<String>.Card
  
  @State private var animatedBonusRemaining: Double = 0
  
  private func startBonusTimeAnimation() {
    animatedBonusRemaining = card.bonusRemaining
    withAnimation(.linear(duration: card.bonusTimeRemaining)) {
      animatedBonusRemaining = 0
    }
  }
  
  // MARK: - Body
  var body: some View {
    GeometryReader { geometry in
      if card.isFaceUp || !card.isMatched {
        ZStack {
          Group {
            if card.isConsumingBonusTime {
              Pie(
                startAngle: .degrees(-90),
                endAngle: .degrees(-animatedBonusRemaining * 360 - 90)
              )
              .onAppear {
                startBonusTimeAnimation()
              }
            }
            else {
              Pie(
                startAngle: .degrees(-90),
                endAngle: .degrees(-card.bonusRemaining * 360 - 90)
              )
            }
          }
          .transition(.identity)
          .padding(5)
          .opacity(0.4)
          
          Text(card.content)
            .font(Font.system(size: fontSize(for: geometry.size)))
            .rotationEffect(.degrees(card.isMatched ? 360 : 0))
            .animation(
              card.isMatched
                ? Animation.linear(duration: 1)
                .repeatForever(autoreverses: false)
                : .default
            )
        }
        .cardify(isFaceUp: card.isFaceUp)
        .transition(.scale)
      }
    }
  }
  
  // MARK: - Drawing constants
  private func fontSize(for size: CGSize) -> CGFloat {
    min(size.width, size.height) * 0.7
  }
}

// MARK: - Preview
struct CardView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      CardView(card: .init(id: 0, isFaceUp: true, content: "😎"))
      CardView(card: .init(id: 0, content: "😎"))
    }
    .previewLayout(.sizeThatFits)
    .padding()
  }
}
