//
//  AkaTanApp.swift
//  AkaTan
//
//  Created by Nobuhiro Akahoshi on 2022/08/13.
//

import SwiftUI

@main
struct AkaTanApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
