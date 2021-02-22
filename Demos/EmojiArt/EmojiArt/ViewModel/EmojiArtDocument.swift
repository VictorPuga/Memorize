//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Víctor Manuel Puga Ruiz on 21/02/21.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
  static let pallete: String = "🐢😎🐶😛🤓"
  
  @Published private var emojiArt = EmojiArt()
  
  @Published private(set) var backgroundImage: UIImage?
  
  var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
  
  // MARK: - Intents
  
  func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
    emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
  }
  
  func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
    if let index = emojiArt.emojis.firstIndex(matching: emoji) {
      emojiArt.emojis[index].x += Int(offset.width)
      emojiArt.emojis[index].y += Int(offset.height)
    }
  }
  
  func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
    if let index = emojiArt.emojis.firstIndex(matching: emoji) {
      emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
    }
  }
  
  func setBackgroundURL(_ url: URL?) {
    emojiArt.backgroundURL = url?.imageURL
    fetchBackgroundImage()
  }
  
  private func fetchBackgroundImage() {
    backgroundImage = nil
    if let url = emojiArt.backgroundURL {
      DispatchQueue.global(qos: .userInitiated).async {
        if let imageData = try? Data(contentsOf: url) {
          DispatchQueue.main.async { [self] in
            if url == emojiArt.backgroundURL {
              backgroundImage = UIImage(data: imageData)
            }
          }
        }
      }
    }
  }
}

extension EmojiArt.Emoji {
  var fontSize: CGFloat { CGFloat(self.size) }
  var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
