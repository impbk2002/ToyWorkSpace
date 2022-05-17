//
//  ScrollViewModifier.swift
//  DemoToycraft
//
//  Created by pbk on 2022/05/17.
//

import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit

#endif
#if canImport(AppKit)
import AppKit

#endif

struct ScrollViewEditor {
    let operation:(InjectingViewType) -> ()
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func buildInjectingView(context: Context) -> InjectingViewType {
        let view = InjectingViewType()
//        DispatchQueue.main.async {
//
//        }
        return view
    }
    
    func updateInjectingView(_ injectingView: InjectingViewType, context: Context) {
        
    }
    
    class Coordinator:NSObject {
        
    }
    
}

#if os(macOS)
extension ScrollViewEditor: NSViewRepresentable {
    typealias InjectingViewType = NSScrollView
    
    func makeNSView(context: Context) -> InjectingViewType {
        buildInjectingView(context: context)
    }
    
    func updateNSView(_ nsView: InjectingViewType, context: Context) {
        updateInjectingView(nsView, context: context)
    }
    
}
#else
extension ScrollViewEditor: UIViewRepresentable {
    typealias InjectingViewType = UIScrollView
    
    func makeUIView(context: Context) -> InjectingViewType {
        buildInjectingView(context: context)
    }
    
    func updateUIView(_ uiView: InjectingViewType, context: Context) {
        updateInjectingView(uiView, context: context)
    }
    
}
#endif
