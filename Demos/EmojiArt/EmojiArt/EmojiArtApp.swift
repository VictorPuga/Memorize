//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Víctor Manuel Puga Ruiz on 21/02/21.
//

import SwiftUI

@main
struct EmojiArtApp: App {
  let store = EmojiArtDocumentStore(named: "Emoji Art")
  var body: some Scene {
    WindowGroup {
      // EmojiArtDocumentView(document: EmojiArtDocument())
      DocumentChooserView()
        .environmentObject(store)
        // .onAppear {
        //   store.addDocument()
        //   store.addDocument(named: "hello")
        // }
    }
  }
}
