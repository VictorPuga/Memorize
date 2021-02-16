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
      ZStack {
        if card.isFaceUp {
          RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.white)
          RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(lineWidth: edgeLineWidth)
          Text(card.content)
        }
        else {
          if !card.isMatched {
            RoundedRectangle(cornerRadius: cornerRadius)
              .fill()
          }
        }
      }
      .font(Font.system(size: fontSize(for: geometry.size)))
    }
  }
  
  // MARK: - Drawing constants
  let cornerRadius: CGFloat = 10
  let edgeLineWidth: CGFloat = 3
  
  func fontSize(for size: CGSize) -> CGFloat {
    min(size.width, size.height) * 0.75
  }
}

// MARK: - Preview
struct CardView_Previews: PreviewProvider {
  static var previews: some View {
    CardView(card: .init(id: 0, content: "😎"))
      .previewLayout(.sizeThatFits)
      .padding()
  }
}
