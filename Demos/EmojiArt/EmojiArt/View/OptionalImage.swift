//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by Víctor Manuel Puga Ruiz on 03/03/21.
//

import SwiftUI

struct OptionalImage: View {
  var uiImage: UIImage?
  
  var body: some View {
    Group {
      if uiImage != nil {
        Image(uiImage: uiImage!)
      }
    }
  }
}
