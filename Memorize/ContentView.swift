//
//  ContentView.swift
//  Memorize
//
//  Created by Víctor Manuel Puga Ruiz on 31/01/21.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    HStack {
      ForEach(0..<4) { item in
        CardView(isFaceUp: true)
      }
    }
    .padding()
    .foregroundColor(.orange)
    .font(.largeTitle)
  }
}

struct CardView: View {
  var isFaceUp: Bool
  
  var body: some View {
    ZStack {
      if isFaceUp {
        RoundedRectangle(cornerRadius: 10)
          .fill(Color.white)
        RoundedRectangle(cornerRadius: 10)
          .stroke(lineWidth: 3)
        Text("👻")
      }
      else {
        RoundedRectangle(cornerRadius: 10)
          .fill()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
