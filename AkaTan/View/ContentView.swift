//
//  ContentView.swift
//  AkaTan
//
//  Created by Nobuhiro Akahoshi on 2022/08/13.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // ひな形にあったItem
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    // 自分が作ったWord
    @FetchRequest(
        entity: Word.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Word.timestamp, ascending: true)],
        predicate: nil,
        animation: .default)
    private var words: FetchedResults<Word>
    
    var body: some View {
        VStack {
            TabView {
                WordListView(modeOfEnJp: .enToJp)
                    .tabItem {
                        ZStack {
                            Image(systemName: "book")
                            Text("英⇒和")
                        }
                    }
                WordListView(modeOfEnJp: .jpToEn)
                    .tabItem {
                        ZStack {
                            Image(systemName: "book")
                            Text("和⇒英")
                        }
                    }
                SettingView()
                    .tabItem {
                        ZStack {
                            Image(systemName: "gear")
                            Text("設定")
                        }
                    }
            }
        }
    }

    private func parseText(_ text: String?) -> some View {
        if text == nil {
            return Text("だめ")
        } else {
            return Text("\(text!)")
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
