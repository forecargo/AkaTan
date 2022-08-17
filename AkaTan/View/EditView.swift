//
//  EditView.swift
//  AkaTan
//
//  Created by Nobuhiro Akahoshi on 2022/08/17.
//

import SwiftUI
import CoreData

struct EditView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    @State private var englishText: String
    @State private var japaneseText: String
    
    private var word: Word
    
    init(editingWord word: Word) {
        // 背景色をクリア
        UITableView.appearance().backgroundColor = .clear
        
        //
        self.word = word
        
        self._englishText = State(initialValue: word.english!)
        self._japaneseText = State(initialValue: word.japanese!)
    }
    
    var body: some View {
        
        VStack {
            NavigationView {
                Form {
                    Section {
                        TextField("英語", text: $englishText)
                            .lineLimit(nil)
                            //.frame(width: 300, height: 100)
                    } header: {
                        Text("英語")
                    }
                    
                    Section {
                        TextField("日本語", text: $japaneseText)
                            .lineLimit(nil)
                            //.frame(width: 300, height: 100)
                    } header: {
                        Text("日本語")
                    }
                }
                .navigationTitle("編集")
                .navigationBarTitleDisplayMode(.inline)
            }
            
            Button(action: {
                word.english = englishText
                word.japanese = japaneseText
                try? viewContext.save()
                dismiss()
            }, label: {
                Text("更新")
                    .fontWeight(.semibold)
                    .frame(width: 160, height: 48)
                    .foregroundColor(Color(.white))
                    .background(Color(.blue))
                    .cornerRadius(24)
            })
        }
        .background(.gray.opacity(0.1))
        .onAppear {
            //self.englishText = words.wrappedValue.first?.english ?? "エラー"
            //self.japaneseText = words.wrappedValue.first?.japanese ?? "エラー"
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        let ctx = PersistenceController.preview.container.viewContext
        var word = Word.create(english: "follow her advice. shirokumakun wo tabete iiyo.", japanese: "彼女の助言に従う", sid: "00001", inContext: ctx)
        EditView(editingWord: word)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
    }
}
