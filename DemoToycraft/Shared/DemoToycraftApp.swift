//
//  DemoToycraftApp.swift
//  Shared
//
//  Created by pbk on 2022/05/10.
//

import SwiftUI

#if os(macOS)
typealias AppDelegateAdaptorType = NSApplicationDelegateAdaptor
#else
typealias AppDelegateAdaptorType = UIApplicationDelegateAdaptor
#endif

@main
struct DemoToycraftApp: App {
    @AppDelegateAdaptorType private var appDelegate:DemoToycraftDelegate
    
    let persistenceController = PersistenceController.shared
    
    @SceneStorage("selectedIndex") private var index = 0
    var body: some Scene {
        MainWindowScene()
    }
}
