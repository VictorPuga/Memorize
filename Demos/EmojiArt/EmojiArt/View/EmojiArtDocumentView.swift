//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Víctor Manuel Puga Ruiz on 21/02/21.
//

import SwiftUI

struct EmojiArtDocumentView: View {
  // MARK: - Properties
  @ObservedObject var document: EmojiArtDocument

  @GestureState private var gestureZoomScale: CGFloat = 1.0
  private var zoomScale: CGFloat {
    document.steadyStateZoomScale * gestureZoomScale
  }
  
  @GestureState private var gesturePanOffset: CGSize = .zero
  private var panOffset: CGSize {
    (document.steadyStatePanOffset + gesturePanOffset) * zoomScale
  }
  
  @GestureState private var gestureEmojiOffset: CGSize = .zero
  
  @GestureState private var gestureEmojiScale: CGFloat = 1.0
  
  @State private var selection: Set<EmojiArt.Emoji> = Set()
  
  @State private var chosenPalette: String = ""
  
  @State private var presentAlert = false
  
  @State private var confirmPaste = false
  
  var isLoading: Bool {
    document.backgroundURL != nil && document.backgroundImage == nil
  }
  
  // MARK: - Init
  init(document: EmojiArtDocument) {
    self.document = document
    _chosenPalette = State(wrappedValue: self.document.defaultPalette)
  }
  
  // MARK: - Body
  var body: some View {
    VStack {
      HStack {
        PaletteChooser(document: document, chosenPalette: $chosenPalette)
        ScrollView(.horizontal) {
          HStack {
            ForEach(chosenPalette.map { String($0) }, id: \.self) { emoji in
              Text(emoji)
                .font(.system(size: defaultEmojiSize))
                .onDrag { NSItemProvider(object: emoji as NSString) }
            }
          }
        }
        Button(action: {
          for emoji in selection {
            document.deleteEmoji(emoji)
            selection.remove(matching: emoji)
          }
        }) {
          Image(systemName: "trash.circle")
        }
        .foregroundColor(.red)
        .font(.system(size: defaultEmojiSize))
        .opacity(selection.isEmpty ? 0 : 1)
        .padding(.leading, 4)
      }
      .padding(.trailing)
      GeometryReader { geometry in
        ZStack {
          Color.white
            .overlay(
              OptionalImage(uiImage: document.backgroundImage)
                .scaleEffect(zoomScale)
                .offset(panOffset)
            )
            .gesture(doubleTapToZoom(in: geometry.size))
            .onTapGesture {
              withAnimation(selectAnimation) {
                selection.removeAll()
              }
            }
          if isLoading {
            Image(systemName: "hourglass")
              .imageScale(.large)
              .spinning()
          } else {
            ForEach(document.emojis) { emoji in
              Text(emoji.text)
                .border(Color.blue, width: selection.contains(matching: emoji) ? 1 : 0)
                .font(animatableWithSize: emoji.fontSize * zoomScale)
                .position(position(for: emoji, in: geometry.size))
                .gesture(dragEmojiGesture(emoji))
                .onTapGesture {
                  withAnimation(selectAnimation) {
                    selection.toggle(matching: emoji)
                    // for emoji in document.emojis {
                    //   selection.insert(emoji)
                    // }
                  }
                }
            }
          }
        }
        .clipped()
        .gesture(panGesture())
        .gesture(zoomGesture())
        .edgesIgnoringSafeArea([.horizontal, .bottom])
        .onReceive(document.$backgroundImage) { image in
          withAnimation {
            zoomToFit(image, in: geometry.size)
          }
        }
        .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
          var location = geometry.convert(location, from: .global)
          location = CGPoint(x: location.x - geometry.size.width / 2, y: location.y - geometry.size.height / 2)
          location = CGPoint(x: location.x - panOffset.width, y: location.y - panOffset.height)
          location = location/zoomScale
          return drop(providers: providers, at: location)
        }
        .navigationBarItems(trailing:
                              Button(action: {
                                if let str = UIPasteboard.general.string, let url = URL(string: str), url != document.backgroundURL {
                                  confirmPaste = true
                                } else {
                                  presentAlert = true
                                }
                              }) {
                                Image(systemName: "doc.on.clipboard")
                                  .imageScale(.large)
                                  .alert(isPresented: $presentAlert) {
                                    Alert(
                                      title: Text("Paste Background"),
                                      message: Text("Copy the URL of an image to the clipboard, and touch the button to make it the background of the document"),
                                      dismissButton: .default(Text("Ok"))
                                    )
                                  }
                              }
        )
      }
      .zIndex(-1)
    }
    .alert(isPresented: $confirmPaste) {
      Alert(
        title: Text("Paste Background"),
        message: Text("Replace background with \(UIPasteboard.general.url?.absoluteString ?? "nothing")?"),
        primaryButton: .default(Text("Ok")) {
          if let str = UIPasteboard.general.string, let url = URL(string: str) {
            document.backgroundURL = url
          } else {
            document.backgroundURL = nil
          }
          
        },
        secondaryButton: .cancel()
      )
    }
  }
  
  private let defaultEmojiSize: CGFloat = 40
  
  private let selectAnimation: Animation = .easeInOut(duration: 0.2)
  
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
        document.steadyStateZoomScale *= finalGestureScale
      }
  }
  
  private func panGesture() -> some Gesture {
    DragGesture()
      .updating($gesturePanOffset) { currentState, gestureState, transaction in
        gestureState = currentState.translation / zoomScale
      }
      .onEnded { finalGestureZoom in
        document.steadyStatePanOffset = document.steadyStatePanOffset + (finalGestureZoom.translation / zoomScale)
      }
  }
  
  private func dragEmojiGesture(_ emoji: EmojiArt.Emoji) -> some Gesture {
    DragGesture()
      .updating($gestureEmojiOffset) { currentState, gestureState, transaction in
        guard selection.contains(matching: emoji) else { return }
        
        let prev = gestureState
        let current = currentState.translation / zoomScale
        
        for emoji in selection {
          document.moveEmoji(emoji, by: current - prev)
        }
        gestureState = current
      }
  }
  
  private func zoomToFit(_ image: UIImage?, in size: CGSize) {
    if let image = image, image.size.width > 0, image.size.height > 0, size.height > 0, size.width > 0 {
      let hZoom = size.width / image.size.width
      let vZoom = size.height / image.size.height
      
      document.steadyStateZoomScale = min(hZoom, vZoom)
      document.steadyStatePanOffset = .zero
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
      document.backgroundURL = url
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
