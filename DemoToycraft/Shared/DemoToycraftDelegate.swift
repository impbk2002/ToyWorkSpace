//
//  DemoToycraftDelegate.swift
//  DemoToycraft
//
//  Created by pbk on 2022/05/10.
//

import Foundation
import SwiftUI
import Combine

#if os(macOS)
fileprivate typealias ApplicationDelegateType = NSApplicationDelegate
typealias ApplicationType = NSApplication
#else
fileprivate typealias ApplicationDelegateType = UIApplicationDelegate
typealias ApplicationType = UIApplication
#endif

class DemoToycraftDelegate: NSObject, ObservableObject, Identifiable, ApplicationDelegateType {
    
    
}

#if os(macOS)
extension DemoToycraftDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        
    }

}
#else
extension DemoToycraftDelegate {
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String) async {
        
    }
}
#endif

#if DEBUG
extension DemoToycraftDelegate {
    static let preview:DemoToycraftDelegate = .init()
}
#endif
