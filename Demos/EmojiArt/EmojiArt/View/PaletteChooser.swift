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
  
  @State private var showPalleteEditor = false
  
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
      Image(systemName: "keyboard")
        .imageScale(.large)
        .onTapGesture {
          showPalleteEditor = true
        }
        .popover(isPresented: $showPalleteEditor) {
          PaletteEditor(chosenPalette: $chosenPalette, isShowing: $showPalleteEditor)
            .frame(minWidth: 300, minHeight: 500)
            .environmentObject(document)
        }
    }
    .fixedSize(horizontal: true, vertical: false)
  }
}

struct PaletteEditor: View {
  // MARK: - Properties
  @EnvironmentObject var document: EmojiArtDocument
  
  @Binding var chosenPalette: String
  @Binding var isShowing: Bool
  
  @State private var paletteName: String = ""
  @State private var emojisToAdd: String = ""
  
  // MARK: - Body
  var body: some View {
    VStack(spacing: 0) {
      ZStack {
        Text("Palette editor")
          .font(.headline)
          .padding()
        HStack {
          Spacer()
          Button(action: {
            isShowing = false
          }) {
            Text("Done")
              .fontWeight(.bold)
          }
          .padding()
        }
      }
      Divider()
      Form {
        Section {
          TextField("Palette Name", text: $paletteName, onEditingChanged: { began in
            if (!began) {
              document.renamePalette(chosenPalette, to: paletteName)
            }
          })
          TextField("Add Emoji", text: $emojisToAdd, onEditingChanged: { began in
            if (!began) {
              chosenPalette = document.addEmoji(emojisToAdd, toPalette: chosenPalette)
              emojisToAdd = ""
            }
          })
        }
        
        Section(header: Text("Remove Emoji")) {
          Grid(chosenPalette.map { String($0) }, id: \.self) { emoji in
            Text(emoji)
              .font(Font.system(size: fontSize))
              .onTapGesture {
                chosenPalette = document.removeEmoji(emoji, fromPalette: chosenPalette)
              }
          }
          .frame(height: height)
        }
        
      }
    }
    .onAppear {
      paletteName = document.paletteNames[chosenPalette] ?? ""
    }
  }
  
  // MARK: - Constants
  var height: CGFloat {
    CGFloat((chosenPalette.count - 1) / 6) * 70 + 70
  }
  
  var fontSize: CGFloat = 40
}

// MARK: - Preview
struct PalleteChooser_Previews: PreviewProvider {
  static let document = EmojiArtDocument()
  static var previews: some View {
    Group {
      PaletteChooser(document: document, chosenPalette: .constant(document.defaultPalette))
        .padding()
      // PaletteEditor(chosenPalette: .constant(document.defaultPalette))
      //   .frame(width: 300, height: 500)
      //   .environmentObject(document)
    }
    .previewLayout(.sizeThatFits)
  }
}
