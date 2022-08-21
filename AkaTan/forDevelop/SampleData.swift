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
    var SubStage: String            // 見出し
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
        newWord.substage = word.SubStage
        
        /*
        newWord.en_missed = 0
        newWord.ja_missed = 0
        newWord.favorite = false
         */
    }
    
    // コミット
    try? context.save()
}

func fetchWordData(context: NSManagedObjectContext, sidOfWord: String) -> Word? {
    let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "sid = %@", sidOfWord)
    let fetchData = try! context.fetch(fetchRequest)
    if !fetchData.isEmpty {
        return fetchData.first
    } else {
        return nil
    }
}



func updateSampleData(context: NSManagedObjectContext, fileName: String) {
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
    
    // Wordテーブル登録
    for word in wordlist {
        if let wordOnDevice: Word = fetchWordData(context: context, sidOfWord: word.wordid) {
            wordOnDevice.japanese = word.Japanese
            wordOnDevice.english = word.English
            wordOnDevice.stage = word.Stage
            wordOnDevice.substage = word.SubStage
            print("\(word.wordid)を更新しました。")
        } else {
            // 何もしない
            print("\(word.wordid)の更新でエラーが生じました。")
        }
        
    }
    
    // コミット
    //try? context.save()
}
