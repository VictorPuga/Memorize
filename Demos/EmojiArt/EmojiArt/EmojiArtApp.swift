//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Víctor Manuel Puga Ruiz on 21/02/21.
//

import SwiftUI

@main
struct EmojiArtApp: App {
  var body: some Scene {
    WindowGroup {
      EmojiArtDocumentView(document: EmojiArtDocument())
    }
  }
}
