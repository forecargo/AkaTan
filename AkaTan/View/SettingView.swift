//
//  SettingView.swift
//  AkaTan
//
//  Created by Nobuhiro Akahoshi on 2022/08/14.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showingUpdatingAlert: Bool = false
    @State private var showingUpdatedAlert: Bool = false
    @State private var showingRegistingAlert: Bool = false
    @State private var showingRegistedAlert: Bool = false
    
    var body: some View {
        VStack {
            Text("システム英単語 ５訂版")
                .font(.headline)
                .padding()
            
            // 更新ボタン
            Button(action: {
                self.showingUpdatingAlert = true
            }, label: {
                Text("データ更新")
                    .fontWeight(.semibold)
                    .frame(width: 160, height: 48)
                    .foregroundColor(Color(.white))
                    .background(Color(.blue))
                    .cornerRadius(24)
            })
            .alert("データの更新", isPresented: $showingUpdatingAlert) {
                Button("キャンセル") {
                    
                }
                Button("更新する") {
                    updateSampleData(context: viewContext, fileName: "words1")
                    updateSampleData(context: viewContext, fileName: "words2")
                    updateSampleData(context: viewContext, fileName: "words3")
                    self.showingUpdatedAlert = true
                }
            } message: {
                Text("データを更新しますか？\n編集した英語・日本語が上書きされます。")
            }
            .alert(isPresented: $showingUpdatedAlert) {
                Alert(title: Text("データの更新"),
                      message: Text("更新が完了しました。"),
                      dismissButton: .default(Text("了解"))
                )
            }
            .padding(.vertical)
            
            
            // 初期化ボタン
            Button(action: {
                self.showingRegistingAlert = true
            }, label: {
                Text("データ初期化")
                    .fontWeight(.semibold)
                    .frame(width: 160, height: 48)
                    .foregroundColor(Color(.white))
                    .background(Color(.red))
                    .cornerRadius(24)
            })
            .alert("データの初期化", isPresented: $showingRegistingAlert) {
                Button("キャンセル") {
                    
                }
                Button("初期化する") {
                    clearSampleData(context: viewContext)
                    registSampleData(context: viewContext, fileName: "words1")
                    registSampleData(context: viewContext, fileName: "words2")
                    registSampleData(context: viewContext, fileName: "words3")
                    self.showingRegistedAlert = true
                }
            } message: {
                Text("データを初期化しますか？\nすべての英語・日本語・ブックマークが初期化されます。")
            }
            .alert(isPresented: $showingRegistedAlert) {
                Alert(title: Text("データの初期化"),
                      message: Text("初期化が完了しました。"),
                      dismissButton: .default(Text("了解"))
                )
            }
            .padding(.vertical)
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
