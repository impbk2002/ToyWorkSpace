//
//  MainWindowScene.swift
//  DemoToycraft
//
//  Created by pbk on 2022/05/10.
//

import Foundation
import SwiftUI

struct MainWindowScene: Scene {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var appDelegate:DemoToycraftDelegate
    @StateObject private var sceneViewModel = MainSceneDelegate()
    
    
    
    var body: some Scene {
        WindowGroup("Main", id: "Main") {
            CustomSideMainView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .environmentObject(sceneViewModel)
        }.onChange(of: scenePhase) { newValue in
            if newValue == .background {
                sceneViewModel.cache.removeAllObjects()
            }
        }
    }
}
