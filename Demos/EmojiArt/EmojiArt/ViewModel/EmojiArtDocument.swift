//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Víctor Manuel Puga Ruiz on 21/02/21.
//

import SwiftUI
import Combine

class EmojiArtDocument: ObservableObject {
  static let pallete: String = "🐢😎🐶😛🤓"
  
  @Published private var emojiArt: EmojiArt
  
  @Published private(set) var backgroundImage: UIImage?
  
  private static let untitled = "EmojiArtDocument.Untitled"
  
  // MARK: - Cancellables
  
  private var autosaveCancellable: AnyCancellable?
  
  private var fetchImageCancellable: AnyCancellable?
  
  // MARK: - init
  
  init() {
    emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: Self.untitled)) ?? EmojiArt()
    autosaveCancellable = $emojiArt.sink { emojiArt in
      UserDefaults.standard.set(emojiArt.json, forKey: Self.untitled)
    }
    fetchBackgroundImage()
  }
  
  // MARK: - Access to the model
  
  var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
  
  // MARK: - Intents
  
  func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
    emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
  }
  
  func deleteEmoji(_ emoji: EmojiArt.Emoji) {
    emojiArt.deleteEmoji(emoji)
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
  
  var backgroundURL: URL? {
    get {
      emojiArt.backgroundURL
    }
    set {
      emojiArt.backgroundURL = newValue?.imageURL
      fetchBackgroundImage()
    }
  }
  
  private func fetchBackgroundImage() {
    backgroundImage = nil
    if let url = emojiArt.backgroundURL {
      fetchImageCancellable?.cancel()
      
      fetchImageCancellable = URLSession.shared.dataTaskPublisher(for: url)
        .map { data, urlResponse in UIImage(data: data) }
        .receive(on: DispatchQueue.main)
        .replaceError(with: nil)
        .assign(to: \.backgroundImage, on: self)
    }
  }
}

extension EmojiArt.Emoji {
  var fontSize: CGFloat { CGFloat(self.size) }
  var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
