//
//  SampleData.swift
//  AkaTan
//
//  Created by Nobuhiro Akahoshi on 2022/08/13.
//

import Foundation
import CoreData

struct jsonWord: Codable {
    var English: String             // 英語
    var Japanese: String            // 日本語
    var wordid: String              // シリアル番号
    var Stage: String               // ステージ
}

func clearSampleData(context: NSManagedObjectContext) {
    // Wordテーブルを全消去
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
    fetchRequest.entity = Word.entity()
    let words = try? context.fetch(fetchRequest) as? [Word]
    for word in words! {
        context.delete(word)
    }
    // コミット
    try? context.save()
}

func registSampleData(context: NSManagedObjectContext, fileName: String) {
    print(fileName)
    // JSONから単語リストを読み込み
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
        fatalError("ファイルが見つかりません。")
    }
    guard let data = try? Data(contentsOf: url) else {
        fatalError("ファイルが読み込めません。")
    }
    print(data)
    let decoder = JSONDecoder()
    guard let wordlist = try? decoder.decode([jsonWord].self, from: data) else {
        fatalError("JSONがデコードできません。")
    }
    
    // Wordテーブルを全消去
    /*
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
    fetchRequest.entity = Word.entity()
    let words = try? context.fetch(fetchRequest) as? [Word]
    for word in words! {
        context.delete(word)
    }
     */
    
    // Wordテーブル登録
    for word in wordlist {
        let newWord = Word(context: context)
        newWord.english = word.English
        newWord.japanese = word.Japanese
        newWord.timestamp = Date()
        newWord.sid = word.wordid
        newWord.stage = word.Stage
        
        /*
        newWord.en_missed = 0
        newWord.ja_missed = 0
        newWord.favorite = false
         */
    }
    
    // コミット
    try? context.save()
}
