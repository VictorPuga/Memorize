//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Víctor Manuel Puga Ruiz on 15/03/21.
//

import SwiftUI

struct PaletteChooser: View {
  // MARK: - Properties  
  @ObservedObject var document: EmojiArtDocument
  
  @Binding var chosenPalette: String
  
  // MARK: - Body
  var body: some View {
    HStack {
      Stepper(
        onIncrement: {
          chosenPalette = document.palette(after: chosenPalette)
        },
        onDecrement: {
          chosenPalette = document.palette(before: chosenPalette)
        }
      ) {
        EmptyView()
      }
      Text(document.paletteNames[chosenPalette] ?? "")
    }
    .fixedSize(horizontal: true, vertical: false)
  }
}

// MARK: - Preview
struct PalleteChooser_Previews: PreviewProvider {
  static var previews: some View {
    PaletteChooser(document: EmojiArtDocument(), chosenPalette: .constant("🐢"))
      .previewLayout(.sizeThatFits)
      .padding()
  }
}
