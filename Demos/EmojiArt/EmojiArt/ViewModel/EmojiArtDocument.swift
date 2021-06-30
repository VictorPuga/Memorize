//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Víctor Manuel Puga Ruiz on 21/02/21.
//

import SwiftUI
import Combine

class EmojiArtDocument: ObservableObject, Identifiable {
  let id: UUID
  
  static let pallete: String = "🐢😎🐶😛🤓"
  
  @Published private var emojiArt: EmojiArt
  
  @Published private(set) var backgroundImage: UIImage?
  
  @Published var steadyStateZoomScale: CGFloat = 1.0
  
  @Published var steadyStatePanOffset: CGSize = .zero
  
  private static let untitled = "EmojiArtDocument.Untitled"
  
  // MARK: - Cancellables
  
  private var autosaveCancellable: AnyCancellable?
  
  private var fetchImageCancellable: AnyCancellable?
  
  // MARK: - init
  
  init(id: UUID? = nil) {
    self.id = id ?? UUID()
    let defaultKey = "EmojiArtDocument.\(self.id.uuidString)"
    emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: defaultKey)) ?? EmojiArt()
    autosaveCancellable = $emojiArt.sink { emojiArt in
      UserDefaults.standard.set(emojiArt.json, forKey: defaultKey)
    }
    fetchBackgroundImage()
  }
  
  var url: URL? {
    didSet { save(emojiArt) }
  }
  
  init(url: URL) {
    id = UUID()
    self.url = url
    emojiArt = EmojiArt(json: try? Data(contentsOf: url)) ?? EmojiArt()
    fetchBackgroundImage()
    autosaveCancellable = $emojiArt.sink { emojiArt in
      self.save(emojiArt)
    }
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
  
  private func save(_ emojiArt: EmojiArt) {
    if url != nil {
      try? emojiArt.json?.write(to: url!)
    }
  }
}

extension EmojiArtDocument: Hashable, Equatable {
  static func == (lhs: EmojiArtDocument, rhs: EmojiArtDocument) -> Bool {
    lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

extension EmojiArt.Emoji {
  var fontSize: CGFloat { CGFloat(self.size) }
  var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
