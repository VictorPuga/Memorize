//
//  Cardify.swift
//  Memorize
//
//  Created by Víctor Manuel Puga Ruiz on 19/02/21.
//

import SwiftUI

struct Cardify: AnimatableModifier {
  var rotation: Double
  
  var isFaceUp: Bool {
    rotation < 90
  }
  
  var animatableData: Double {
    get { rotation }
    set { rotation = newValue }
  }
  
  init(isFaceUp: Bool) {
    rotation = isFaceUp ? 0 : 180
  }
  
  func body(content: Content) -> some View {
    ZStack {
      Group {
        RoundedRectangle(cornerRadius: cornerRadius)
          .fill(Color.white)
        RoundedRectangle(cornerRadius: cornerRadius)
          .stroke(lineWidth: edgeLineWidth)
        content
      }
      .opacity(isFaceUp ? 1 : 0)
      RoundedRectangle(cornerRadius: cornerRadius)
        .fill()
        .opacity(isFaceUp ? 0 : 1)
    }
    .rotation3DEffect(.degrees(rotation), axis: (0, 1, 0))
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
