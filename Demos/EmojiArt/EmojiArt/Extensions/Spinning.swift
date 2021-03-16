//
//  Spinning.swift
//  EmojiArt
//
//  Created by Víctor Manuel Puga Ruiz on 15/03/21.
//

import SwiftUI

struct Spinning: ViewModifier {
  @State var isVisible = false
  
  func body(content: Content) -> some View {
    content
      .rotationEffect(Angle(degrees: isVisible ? 360 : 0))
      .animation(
        Animation.linear(duration: 1)
          .repeatForever(autoreverses: false)
      )
      .onAppear { isVisible = true }
  }
}

extension View {
  func spinning() -> some View {
    self.modifier(Spinning())
  }
}
