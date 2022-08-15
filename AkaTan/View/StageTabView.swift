//
//  StageTabView.swift
//  AkaTan
//
//  Created by Nobuhiro Akahoshi on 2022/08/15.
//

import SwiftUI

enum ModeOfEnJp {
    case enToJp     // 英和モード
    case jpToEn     // 和英モード
}


struct StageTabView: View {
    // イニシャライザ
    init(modeOfEnJp: ModeOfEnJp, stageNum: Int) {
        self.selectedStage = stageNum
        self.modeOfEnJp = modeOfEnJp
    }
    
    @State private var selectedStage = 0
    @State private var modeOfEnJp: ModeOfEnJp
    
    
    let stages: [String] = ["すべて", "Stage1", "Stage2", "Stage3", "Stage4", "Stage5"]
    
    var body: some View {
        VStack {
            // コンテンツ部分
            TabView(selection: $selectedStage) {
                ForEach(0..<self.stages.count) { num in
                    ZStack {
                        //Text("\(stages[num])")
                        WordListView(modeOfEnJp: modeOfEnJp)
                    }
                    .tag(num)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // タブ部分
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    HStack {
                        Spacer()
                        ForEach(0..<self.stages.count) { num in
                            Text("\(stages[num])")
                                .font(.headline)
                                .padding(.init(top: 4, leading: 4, bottom: 4, trailing: 4))
                                .decorate(isSelected: num == selectedStage)
                                .id(num)
                                .tag(num)
                                .onTapGesture {
                                    withAnimation {
                                        selectedStage = num
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
                }
            }
            
        }
    }
}

struct TabItem: ViewModifier {

    let isSelected: Bool

    @ViewBuilder
    func body(content:Content) -> some View {
        if isSelected {
            content
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(Capsule())
        } else {
            content
                .foregroundColor(Color(.label))
        }
    }
}

extension View {
    func decorate(isSelected: Bool) -> some View {
        self.modifier(TabItem(isSelected: isSelected))
    }
}

struct StageTabView_Previews: PreviewProvider {
    static var previews: some View {
        StageTabView(modeOfEnJp: .enToJp, stageNum: 0)
    }
}
