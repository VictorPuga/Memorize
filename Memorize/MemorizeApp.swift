//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Víctor Manuel Puga Ruiz on 31/01/21.
//

import SwiftUI

@main
struct MemorizeApp: App {
  let game = EmojiMemoryGame()
  
  var body: some Scene {
    WindowGroup {
      MainMenuView(viewModel: game)
    }
  }
}
