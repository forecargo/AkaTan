//
//  WordCardView.swift
//  AkaTan
//
//  Created by Nobuhiro Akahoshi on 2022/08/14.
//

import SwiftUI
// イメージ
// ランダムに単語を選んでテストができる
// 間違った単語には印が付けられる（「間違った！」ボタン）
// 英和モードと和英モードの2種類がある
// 覚えの悪い単語ほど出現確率が上がる。
// 間違った日（間違ったボタンを押した日）がカレンダーで分かる
// 詳しいことを調べるときには外部サイトに飛ばすことができる

struct WordCardView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var words: FetchRequest<Word>
    
    @State var isFront: Bool
    
    init(sidOfWord sid: String, defautSide: Bool) {
        words = FetchRequest<Word>(
            entity: Word.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Word.sid, ascending: true)],
            predicate: NSPredicate(format: "sid == %@", sid),
            animation: .default
        )
        _isFront = State(initialValue: defautSide ? true : false)
        print(defautSide)
    }
    
    var body: some View {
        VStack {
            Flip(
                isFront: isFront,
                front: {
                    FrontCard()
                },
                back: {
                    BackCard()
                })
        }.onTapGesture {
            withAnimation(.easeInOut(duration: 1)) {
                if isFront {
                    words.wrappedValue.first!.en_tapped = words.wrappedValue.first!.en_tapped + 1
                } else {
                    words.wrappedValue.first!.jp_tapped = words.wrappedValue.first!.jp_tapped + 1
                }
                words.wrappedValue.first!.tapped = words.wrappedValue.first!.tapped + 1
                try? viewContext.save()
                isFront.toggle()
            }
        }
    }
    
    private func FrontCard() -> some View {
        Card(.en)
        //Text("\(words.wrappedValue.first!.sid!)")
    }
    
    private func BackCard() -> some View {
        Card(.jp)
        //EmptyView()
    }
    
    private enum mode {
        case jp
        case en
    }
    
    private func Card(_ mode: mode) -> some View {
        ZStack {
            let cardWidth = CGFloat(300)
            let cardHeight = CGFloat(150)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .frame(width: cardWidth - CGFloat(10), height: cardHeight)
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    mode == .en ? .red : .blue,
                                    mode == .en ? .orange : .purple
                                ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: cardWidth - CGFloat(10), height: 20)
                    .offset(y: -1 * cardHeight / 2 + 10)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 10)
            .padding()
            
            // 英語・日本語
            Text(mode == .en ? "\(words.wrappedValue.first!.english!)" : words.wrappedValue.first!.japanese!)
                .frame(width: cardWidth - 10)
                .font(.system(size: 18, design: .rounded))
                .offset(y: 5)
            
            // SID
            Text("\(words.wrappedValue.first!.sid!)")
                .font(.caption)
                .foregroundColor(.gray)
                .offset(x: -120, y: -45)
            
            // Info
            /*
            Text("\(words.wrappedValue.first!.en_tapped), \(words.wrappedValue.first!.jp_tapped), \(words.wrappedValue.first!.favorite ? "True" : "False") \(words.wrappedValue.first!.stage!)")
                .font(.caption)
                .foregroundColor(.gray)
                .offset(x: -120, y: 70)
            */
            // お気に入りアイコン
            Image(systemName: words.wrappedValue.first!.favorite ? "bookmark.fill" : "bookmark")
                .font(.title)
                .foregroundColor(words.wrappedValue.first!.favorite ? .yellow : .yellow.opacity(0.7))
                .offset(x: 120, y: -70)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        words.wrappedValue.first!.favorite.toggle()
                        try! viewContext.save()
                    }
                    print(words.wrappedValue.first!.favorite)
                }
        }
    }
}


struct WordCardView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ctx = PersistenceController.preview.container.viewContext
        var word = Word.create(english: "follow her advice 2", japanese: "彼女の助言に従う", sid: "00001", inContext: ctx)
        WordCardView(sidOfWord: "00001", defautSide: true)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
