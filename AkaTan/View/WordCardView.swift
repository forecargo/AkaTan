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
// 0.2.0に向けた目標
// ・スプラッシュスクリーン
// ・ダークモードへの対応
// ・横向き画面への対応
// 0.3.0に向けた対応
// ・単語の登録・削除機能の追加（これでゼロ件でも申請できる？）

struct WordCardView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var words: FetchRequest<Word>
    var modeOfEnJp: ModeOfEnJp
    
    @State var isFront: Bool
    @State var isShowingEditPage: Bool = false
    
    init(sidOfWord sid: String, defautSide: Bool) {
        words = FetchRequest<Word>(
            entity: Word.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Word.sid, ascending: true)],
            predicate: NSPredicate(format: "sid == %@", sid),
            animation: .default
        )
        _isFront = State(initialValue: defautSide ? true : false)
        modeOfEnJp = defautSide ? .enToJp : .jpToEn
        print(defautSide)
    }
    
    var body: some View {
        VStack {
            // Flip(isFront: isFront, front: { FrontCard() }, back: { BackCard() })
            NewFlipView(isFront, front: {FrontCard()}, back: {BackCard()})
        }
        .padding([.top, .bottom] , -15)
        .sheet(isPresented: $isShowingEditPage) {
            EditView(editingWord: words.wrappedValue.first!)
        }
        .onTapGesture {
            // タップ数をインクリメント
            if isFront {
                words.wrappedValue.first!.en_tapped = words.wrappedValue.first!.en_tapped + 1
            } else {
                words.wrappedValue.first!.jp_tapped = words.wrappedValue.first!.jp_tapped + 1
            }
            words.wrappedValue.first!.tapped = words.wrappedValue.first!.tapped + 1
            try? viewContext.save()
            // カードを裏返した後、５秒後に元に戻す。
            isFront.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                isFront = modeOfEnJp == .enToJp ? true : false
            }
        }
        .onLongPressGesture {
            // 編集
            isShowingEditPage.toggle()
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
            GeometryReader { geometry in
                let cardWidth = geometry.size.width
                let cardHeight = CGFloat(150)
                
                ZStack {
                    // 1番下の白い板
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .frame(width: cardWidth, height: cardHeight)
                    
                    // 上のバー
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
                        .frame(width: cardWidth, height: 20)
                        .offset(y: -1 * cardHeight / 2 + 10)
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 10)
                .padding(0)
                
                // 英語・日本語
                Text(mode == .en ? "\(words.wrappedValue.first!.english!)" : words.wrappedValue.first!.japanese!)
                    .frame(width: cardWidth - 10, height: cardHeight)
                    .foregroundColor(.black)
                    .font(.system(size: 18, design: .rounded))
                    .offset(y: 5)
                
                // SID
                Text("\(words.wrappedValue.first!.sid!)")
                    .frame(width: cardWidth - 10, height: cardHeight, alignment: .leading)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .offset(x: 10, y: -1 * cardHeight / 2 + 30)
                
                // Info
                /*
                 Text("\(words.wrappedValue.first!.en_tapped), \(words.wrappedValue.first!.jp_tapped), \(words.wrappedValue.first!.favorite ? "True" : "False") \(words.wrappedValue.first!.stage!)")
                 .font(.caption)
                 .foregroundColor(.gray)
                 .offset(x: -120, y: 70)
                 */
                // お気に入りアイコン
                Image(systemName: words.wrappedValue.first!.favorite ? "bookmark.fill" : "bookmark")
                    .frame(width: cardWidth - 10, height: cardHeight, alignment: .trailing)
                    .font(.title)
                    .foregroundColor(words.wrappedValue.first!.favorite ? .yellow : .yellow.opacity(0.7))
                    .offset(x: 0, y: -1 * cardHeight / 2)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            words.wrappedValue.first!.favorite.toggle()
                            try! viewContext.save()
                        }
                        print(words.wrappedValue.first!.favorite)
                    }
            } // geometry
        }
        .frame(height: CGFloat(170))
        
    }
}


struct WordCardView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ctx = PersistenceController.preview.container.viewContext
        var word = Word.create(english: "follow her advice. shirokumakun wo tabete iiyo.", japanese: "彼女の助言に従う", sid: "00001", inContext: ctx)
        WordCardView(sidOfWord: "00001", defautSide: true)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
