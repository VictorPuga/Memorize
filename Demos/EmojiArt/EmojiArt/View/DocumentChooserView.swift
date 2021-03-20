//
//  DocumentChooserView.swift
//  EmojiArt
//
//  Created by Víctor Manuel Puga Ruiz on 19/03/21.
//

import SwiftUI

struct DocumentChooserView: View {
  // MARK: - Properties
  @EnvironmentObject var store: EmojiArtDocumentStore
  
  @State private var editMode: EditMode = .inactive
  
  // MARK: - Body
  var body: some View {
    NavigationView {
      List {
        ForEach(store.documents) { document in
          NavigationLink(
            destination:
              EmojiArtDocumentView(document: document)
              .navigationBarTitle(store.name(for: document))
          ) {
            EditableText(store.name(for: document), isEditing: editMode.isEditing) { name in
              store.setName(name, for: document)
            }
          }
        }
        .onDelete { indexSet in
          withAnimation {
            indexSet
              .map { store.documents[$0] }
              .forEach { document in
                store.removeDocument(document)
              }
          }
        }
      }
      .listStyle(PlainListStyle())
      .navigationTitle(store.name)
      .navigationBarItems(
        leading:
          Button(action: {
            store.addDocument()
          }) {
            Image(systemName: "plus")
              .imageScale(.large)
          },
        trailing: EditButton()
      )
      .environment(\.editMode, $editMode)
    }
  }
}

// MARK: - Preview
struct DocumentChooserView_Previews: PreviewProvider {
  static var previews: some View {
    DocumentChooserView()
      .environmentObject(EmojiArtDocumentStore())
      .previewLayout(.sizeThatFits)
      .padding()
  }
}
