//
//  WordListView.swift
//  AkaTan
//
//  Created by Nobuhiro Akahoshi on 2022/08/14.
//

import SwiftUI

struct WordListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    let generator = UINotificationFeedbackGenerator()
    
    private var mode: ModeOfEnJp
    @State private var modeOfFiltered: Bool = false
    
    // イニシャライザ
    init(modeOfEnJp: ModeOfEnJp) {
        self.mode = modeOfEnJp
    }
    
    // 自分が作ったWord
    @FetchRequest(
        entity: Word.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Word.sid, ascending: true)
        ],
        predicate: nil,
        animation: nil)
    private var words: FetchedResults<Word>
    
    @State private var searchText = ""
    // TabView用
    @State private var substages: [String] = ["すべて"]
    @State private var selectedStage = 0
    
    var body: some View {
        
        VStack {
            // NavigationView
            NavigationView {
                ScrollView(.vertical) {
                    ScrollViewReader { proxy in
                        LazyVStack(alignment: .center, spacing: 0) {
                            EmptyView()
                                .id(0)
                            ForEach(words) { word in
                                WordCardView(sidOfWord: word.sid!, defautSide: mode == .enToJp ? true : false)
                            }
                        }
                        .navigationBarTitle(
                            Text(mode == .enToJp ? "英⇒和" : "和⇒英"),
                            displayMode: .inline)
                        .navigationBarItems(
                            leading: Button(action: {
                                withAnimation(.easeInOut) {
                                    self.generator.notificationOccurred(.success)
                                    self.modeOfFiltered.toggle()
                                    filterExec()
                                }
                            }, label: {
                                Image(systemName: modeOfFiltered ? "bookmark.fill" : "bookmark")
                            }),
                            trailing: Button(action: {
                                //
                            }, label: {
                                Image(systemName: "chevron.up")
                                    .onTapGesture {
                                        withAnimation {
                                            proxy.scrollTo(0)
                                        }
                                    }
                            })
                        )
                    } // scrollviewreader
                    
                } // scrollview
            }
            .padding(.bottom, -8)
            .searchable(
                text: $searchText,
                placement: .automatic,
                prompt: Text("英語または日本語で検索")
            )
            .onSubmit(of: .search) {
                filterExec()
            }
            .onChange(of: searchText) { text in
                filterExec()
            }
            
            // サブステージ（見出し）
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    HStack {
                        Spacer()
                        ForEach(Array(substages.enumerated()), id:\.offset) { num, substage in
                            Text("\(substage)")
                                .font(.headline)
                                .padding(.init(top: 4, leading: 4, bottom: 4, trailing: 4))
                                .decorate(isSelected: num == selectedStage)
                                .id(num)
                                .tag(num)
                                .onTapGesture {
                                    withAnimation {
                                        self.selectedStage = num
                                        filterExec()
                                    }
                                }
                            Spacer()
                        }
                    }
                    .onChange(of: selectedStage, perform: { index in
                        withAnimation {
                            proxy.scrollTo(index, anchor: .center)
                        }
                    })
                } // scrollviewreader
            } // scrollview
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            mode == .enToJp ? .orange : .blue,
                            mode == .enToJp ? .red : .purple
                        ]),
                    startPoint: .leading,
                    endPoint: .trailing
                ).opacity(0.5)
            )
            .onAppear {
                self.substages.append(contentsOf: self.getSubStages())
            }
            
        }
        
    }
    
    //
    func filterExec() {
        // CoreData対応
        let stagePredicate: NSPredicate = NSPredicate(format: "substage contains %@", substages[selectedStage])   // ステージフィルタ
        let bookmarkPredicate: NSPredicate = NSPredicate(format: "favorite == %@", NSNumber(true))          // ブックマークフィルタ
        let englishPredicate: NSPredicate = NSPredicate(format: "english contains %@ OR japanese contains %@", self.searchText, self.searchText)     // キーワードフィルタ
        
        // 検索フィルタの組み込み
        var predicates: [NSPredicate] = []
        
        // ステージフィルタ
        if self.selectedStage != 0 {
            predicates.append(stagePredicate)
        }
        
        // ブックマークフィルタ
        if self.modeOfFiltered {
            predicates.append(bookmarkPredicate)
        }
        
        // キーワードフィルタ
        if self.searchText != "" {
            predicates.append(englishPredicate)
            //predicates.append(japanesePredicate)
        }
        
        // 検索
        words.nsPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
    func getSubStages() -> [String] {
        var substages: [String] = []
        for word in self.words {
            if substages.firstIndex(of: word.substage!) == nil {
                substages.append(word.substage!)
            }
        }
        return substages.sorted()
    }
}

struct WordListView_Previews: PreviewProvider {
    static var previews: some View {
        WordListView(modeOfEnJp: .enToJp)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
