//
//  SettingView.swift
//  AkaTan
//
//  Created by Nobuhiro Akahoshi on 2022/08/14.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        VStack {
            Text("システム英単語 ５訂版")
                .font(.headline)
                .padding()
            Button(action: {
                clearSampleData(context: viewContext)
                registSampleData(context: viewContext, fileName: "words1")
                registSampleData(context: viewContext, fileName: "words2")
                registSampleData(context: viewContext, fileName: "words3")
            }, label: {
                Text("データ初期化")
                        .fontWeight(.semibold)
                        .frame(width: 160, height: 48)
                        .foregroundColor(Color(.white))
                        .background(Color(.blue))
                        .cornerRadius(24)
        })
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
