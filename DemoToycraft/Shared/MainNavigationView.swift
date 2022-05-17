//
//  MainNavigationView.swift
//  DemoToycraft
//
//  Created by pbk on 2022/05/13.
//

import SwiftUI

struct MainNavigationView: View {
    @State private var index:Int?
    
    var body: some View {
        NavigationView {
            List(0..<4, selection: $index) { idx in
                NavigationLink("\(idx)", tag: idx, selection: $index) {
                    if index == 0 {
                        Text("plz help")
                    } else {
                        TabView{
                            ScrollView{
                                NavigationLink.init {
                                    Text("Very deep detail")
                                        .navigationBarTitle(Text("title"))
                                    
                                } label: {
                                    Text("tap me")
                                }.isDetailLink(true)
                                
                                Text("A")
                                
                            }.tabItem {
                                Text("A")
                            }
                            ScrollView{
                                Text("B")
                                
                                
                            }.tabItem {
                                Text("B")
                            }
                            ScrollView{
                                Text("C")
                                
                            }.tabItem {
                                Text("C")
                            }
                        }.tabViewStyle(.automatic)

                    }
                }.isDetailLink(true)
            }
        }.navigationViewStyle(.columns)
    }
}

struct MainNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        MainNavigationView()
    }
}
