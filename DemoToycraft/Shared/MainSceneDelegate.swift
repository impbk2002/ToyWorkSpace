//
//  MainSceneDelegate.swift
//  DemoToycraft
//
//  Created by pbk on 2022/05/10.
//

import Foundation

class MainSceneDelegate: NSObject, ObservableObject, Identifiable {
    let cache = NSCache<NSString,AnyObject>()
    
    override init() {
        super.init()
        cache.delegate = self
    }
}

extension MainSceneDelegate: NSCacheDelegate {
    
}
