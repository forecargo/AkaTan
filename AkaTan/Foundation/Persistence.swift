//
//  Persistence.swift
//  AkaTan
//
//  Created by Nobuhiro Akahoshi on 2022/08/13.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // 元からあったItemのダミーデータ
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        
        // JSONから読み込む
        // JSONから単語リストを読み込み
        guard let url = Bundle.main.url(forResource: "words1", withExtension: "json") else {
            fatalError("ファイルが見つかりません。")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("ファイルが読み込めません。")
        }
        let decoder = JSONDecoder()
        guard let wordlist = try? decoder.decode([jsonWord].self, from: data) else {
            fatalError("JSONがデコードできません。")
        }
        
        // Wordテーブル登録
        for word in wordlist {
            let newWord = Word(context: viewContext)
            newWord.english = word.English
            newWord.japanese = word.Japanese
            newWord.timestamp = Date()
            newWord.sid = word.wordid
            newWord.stage = word.Stage
        }
        
        
        
        /*
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
         */
        // 自分で作ったWordのダミーデータ
        // Wordテーブルの初期値
        /*
        let wordlist = [
            ["001", "follow her advice", "彼女の助言に従う"],
            ["002", "consider the problem seriously", "真剣にその問題を考える"],
            ["003", "increase by 20%", "20%増加する"],
            ["004", "increase by 50%", "50%増加する"]
        ]
        for i in 0..<wordlist.count {
            let newWord = Word(context: viewContext)
            newWord.sid = wordlist[i][0]
            newWord.english = wordlist[i][1]
            newWord.japanese = wordlist[i][2]
            newWord.en_missed = 0
            newWord.ja_missed = 0
            newWord.favorite = false
        }
         */
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "AkaTan")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
