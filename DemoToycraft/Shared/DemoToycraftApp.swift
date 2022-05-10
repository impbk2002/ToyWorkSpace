//
//  DemoToycraftApp.swift
//  Shared
//
//  Created by pbk on 2022/05/10.
//

import SwiftUI

@main
struct DemoToycraftApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}