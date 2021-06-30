//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Víctor Manuel Puga Ruiz on 21/02/21.
//

import SwiftUI

@main
struct EmojiArtApp: App {
  static let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  let store = EmojiArtDocumentStore(directory: url)
  
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
