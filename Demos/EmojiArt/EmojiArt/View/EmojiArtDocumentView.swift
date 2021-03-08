//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Víctor Manuel Puga Ruiz on 21/02/21.
//

import SwiftUI

struct EmojiArtDocumentView: View {
  @ObservedObject var document: EmojiArtDocument
  
  @State private var steadyStateZoomScale: CGFloat = 1.0
  @GestureState private var gestureZoomScale: CGFloat = 1.0
  private var zoomScale: CGFloat {
    steadyStateZoomScale * gestureZoomScale
  }
  
  @State private var steadyStatePanOffset: CGSize = .zero
  @GestureState private var gesturePanOffset: CGSize = .zero
  private var panOffset: CGSize {
    (steadyStatePanOffset + gesturePanOffset) * zoomScale
  }

  
  var body: some View {
    VStack {
      ScrollView(.horizontal) {
        HStack {
          ForEach(EmojiArtDocument.pallete.map { String($0) }, id: \.self) { emoji in
            Text(emoji)
              .font(.system(size: defaultEmojiSize))
              .onDrag { NSItemProvider(object: emoji as NSString) }
          }
        }
      }
      .padding(.horizontal)
      .layoutPriority(1)
      GeometryReader { geometry in
        ZStack {
          Color.white
            .overlay(
              OptionalImage(uiImage: document.backgroundImage)
                .scaleEffect(zoomScale)
                .offset(panOffset)
            )
            .gesture(doubleTapToZoom(in: geometry.size))
          ForEach(document.emojis) {emoji in
            Text(emoji.text)
              .font(animatableWithSize: emoji.fontSize * zoomScale)
              .position(position(for: emoji, in: geometry.size))
          }
        }
        .clipped()
        .gesture(panGesture())
        .gesture(zoomGesture())
        .edgesIgnoringSafeArea([.horizontal, .bottom])
        .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
          var location = geometry.convert(location, from: .global)
          location = CGPoint(x: location.x - geometry.size.width / 2, y: location.y - geometry.size.height / 2)
          location = CGPoint(x: location.x - panOffset.width, y: location.y - panOffset.height)
          location = location/zoomScale
          return drop(providers: providers, at: location)
        }
      }
    }
  }
  
  private let defaultEmojiSize: CGFloat = 40
  
  private func doubleTapToZoom(in size: CGSize) -> some Gesture {
    TapGesture(count: 2)
      .onEnded {
        withAnimation {
          zoomToFit(document.backgroundImage, in: size)
        }
      }
  }
  
  private func zoomGesture() -> some Gesture {
    MagnificationGesture()
      .updating($gestureZoomScale) { currentState, gestureState, transaction in
        gestureState = currentState
      }
      .onEnded { finalGestureScale in
        steadyStateZoomScale *= finalGestureScale
      }
  }
  
  private func panGesture() -> some Gesture {
    DragGesture()
      .updating($gesturePanOffset) { currentState, gestureState, transaction in
        gestureState = currentState.translation / zoomScale
      }
      .onEnded { finalGestureZoom in
        steadyStatePanOffset = steadyStatePanOffset + (finalGestureZoom.translation / zoomScale)
      }
  }
  
  private func zoomToFit(_ image: UIImage?, in size: CGSize) {
    if let image = image, image.size.width > 0, image.size.height > 0 {
      let hZoom = size.width / image.size.width
      let vZoom = size.height / image.size.height
      
      steadyStateZoomScale = min(hZoom, vZoom)
      steadyStatePanOffset = .zero
    }
  }
  
  private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
    var location = emoji.location
    location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
    location = CGPoint(x: location.x + size.width/2, y: location.y + size.height/2)
    location = CGPoint(x: location.x + panOffset.width, y: location.y + panOffset.height)
    return location
  }
  
  private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
    var found = providers.loadFirstObject(ofType: URL.self) { url in
      document.setBackgroundURL(url)
    }
    if !found {
      found = providers.loadFirstObject(ofType: String.self) { string in
        document.addEmoji(string, at: location, size: defaultEmojiSize)
      }
    }
    return found
  }
}

struct EmojiArtDocumentView_Previews: PreviewProvider {
  static var previews: some View {
    EmojiArtDocumentView(document: EmojiArtDocument())
  }
}
