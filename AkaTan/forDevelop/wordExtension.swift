//
//  wordExtension.swift
//  AkaTan
//
//  Created by Nobuhiro Akahoshi on 2022/08/14.
//

import Foundation
import CoreData

extension Word {
    static func create(
        english: String,
        japanese: String,
        sid: String,
        inContext ctx: NSManagedObjectContext
    ) -> Self {
        let word = self.init(context: ctx)
        word.english = english
        word.japanese = japanese
        word.sid = sid
        word.timestamp = Date()
        word.stage = "固定値"
        return word
    }
}
