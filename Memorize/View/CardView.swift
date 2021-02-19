//
//  CardView.swift
//  Memorize
//
//  Created by Víctor Manuel Puga Ruiz on 15/02/21.
//

import SwiftUI

struct CardView: View {
  var card: MemoryGame<String>.Card
  
  // MARK: - Body
  var body: some View {
    GeometryReader { geometry in
      if !card.isMatched || !card.isMatched {
        ZStack {
          Pie(startAngle: .degrees(-90), endAngle: .degrees(30))
            .padding(5)
            .opacity(0.4)
          Text(card.content)
        }
        .cardify(isFaceUp: card.isFaceUp)
        .font(Font.system(size: fontSize(for: geometry.size)))
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
