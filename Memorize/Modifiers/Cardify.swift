//
//  Cardify.swift
//  Memorize
//
//  Created by Víctor Manuel Puga Ruiz on 19/02/21.
//

import SwiftUI

struct Cardify: ViewModifier {
  var isFaceUp: Bool
  func body(content: Content) -> some View {
    ZStack {
      if isFaceUp {
        RoundedRectangle(cornerRadius: cornerRadius)
          .fill(Color.white)
        RoundedRectangle(cornerRadius: cornerRadius)
          .stroke(lineWidth: edgeLineWidth)
        content
      }
      else {
        RoundedRectangle(cornerRadius: cornerRadius)
          .fill()
      }
    }
  }
  
  private let cornerRadius: CGFloat = 10
  private let edgeLineWidth: CGFloat = 3
}

extension View {
  func cardify(isFaceUp: Bool) -> some View {
    modifier(Cardify(isFaceUp: isFaceUp))
  }
}

struct Cardify_Previews: PreviewProvider {
  static var previews: some View {
    Text("Hi")
      .modifier(Cardify(isFaceUp: true))
      .previewLayout(.sizeThatFits)
  }
}
