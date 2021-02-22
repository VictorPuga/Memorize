//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Víctor Manuel Puga Ruiz on 21/02/21.
//

import SwiftUI

struct EmojiArtDocumentView: View {
  @ObservedObject var document: EmojiArtDocument
  
  var body: some View {
    VStack {
      ScrollView(.horizontal) {
        HStack {
          ForEach(EmojiArtDocument.pallete.map { String($0) }, id: \.self) { emoji in
            Text(emoji)
              .font(.system(size: defaultEmojiSize))
              .onDrag { NSItemProvider(object: emoji as NSString) }
          }
        }
      }
      .padding(.horizontal)
      GeometryReader { geometry in
        ZStack {
          Rectangle()
            .foregroundColor(.white)
            .overlay(
              Group {
                if document.backgroundImage != nil {
                  Image(uiImage: document.backgroundImage!)
                }
              }
            )
            .edgesIgnoringSafeArea([.horizontal, .bottom])
            .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
              var location = geometry.convert(location, from: .global)
              location = CGPoint(x: location.x - geometry.size.width / 2, y: location.y - geometry.size.height / 2)
              return drop(providers: providers, at: location)
            }
          ForEach(document.emojis) {emoji in
            Text(emoji.text)
              .font(font(for: emoji))
              .position(position(for: emoji, in: geometry.size))
          }
        }
      }
    }
  }
  
  private let defaultEmojiSize: CGFloat = 40
  
  private func font(for emoji: EmojiArt.Emoji) -> Font {
    .system(size: emoji.fontSize)
  }
  
  private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
    CGPoint(x: emoji.location.x + size.width/2, y: emoji.location.y + size.height/2)
  }
  
  private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
    var found = providers.loadFirstObject(ofType: URL.self) { url in
      document.setBackgroundURL(url)
    }
    if !found {
      found = providers.loadFirstObject(ofType: String.self) { string in
        document.addEmoji(string, at: location, size: defaultEmojiSize)
      }
    }
    return found
  }
}

struct EmojiArtDocumentView_Previews: PreviewProvider {
  static var previews: some View {
    EmojiArtDocumentView(document: EmojiArtDocument())
  }
}
