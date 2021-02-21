//
//  MainMenuView.swift
//  Memorize
//
//  Created by Víctor Manuel Puga Ruiz on 15/02/21.
//

import SwiftUI

struct MainMenuView: View {
  @ObservedObject var viewModel: EmojiMemoryGame
  @State private var selected: UUID?
  
  // MARK: - Body
  var body: some View {
    NavigationView {
      List(viewModel.themes) { theme in
        NavigationLink(
          destination: EmojiMemoryGameView(viewModel: viewModel),
          tag: theme.id,
          selection: $selected
        ) {
          Text("\(theme.emojis[0]) \(theme.name)")
        }
      }
      .listStyle(InsetGroupedListStyle())
      .navigationBarTitle(Text("Memorize"))
      .navigationBarItems(
        trailing: Button(action: {
          withAnimation {
            addTheme()
          }
        }) {
          Image(systemName: "plus")
        }
      )
    }
    .navigationViewStyle(DoubleColumnNavigationViewStyle())
    .onChange(of: selected) { value in
      if let selection = value {
        handleChange(selection)
      }
    }
  }
  
  func handleChange(_ id: UUID) {
    viewModel.startGame(
      with: viewModel.themes.firstIndexWithId(id)!
    )
  }
  
  func addTheme() {
    let newTheme = Theme(
      name: "My theme \(viewModel.themes.count + 1)",
      emojis: (0..<8).map { _ in String.randomEmoji },
      pairs: .random,
      color: .random
    )
    viewModel.addTheme(newTheme)
  }
}

// MARK: - Preview
struct MainMenu_Previews: PreviewProvider {
  static var previews: some View {
    MainMenuView(viewModel: EmojiMemoryGame())
  }
}
