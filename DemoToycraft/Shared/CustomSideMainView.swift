//
//  CustomSideMainView.swift
//  DemoToycraft
//
//  Created by pbk on 2022/05/16.
//

import SwiftUI

struct CustomSideMainView: View {
    @State private var menuOpened = true
    @State private var selection:CustomSideMainCase = .A
    @StateObject private var firstViewModel = ModelObject()
    var body: some View {
        viewProvider(selection)
            .sideMenu(isShowing: $menuOpened) {
                List(CustomSideMainCase.allCases, id: \.self) { item in
                    Button(item.rawValue) {
                        withAnimation {
                            selection = item
                            menuOpened = false
                        }
                    }
                }
            }
    }
    
    @ViewBuilder
    private func viewProvider(_ menu:CustomSideMainCase) -> some View {
        switch menu {
        case .A:
            TabView1(viewModel: firstViewModel, menuOpened: $menuOpened)
        case .B:
            TabView {
                NavigationView{
                    Text("4")
                        .sideMenuButton(menuState: $menuOpened)
                }.navigationViewStyle(.stack)
                    .tabItem {
                        Text("1")
                    }
                NavigationView{
                    Text("5")
                        .sideMenuButton(menuState: $menuOpened)
                }.navigationViewStyle(.stack)
                    .tabItem {
                        Text("2")
                    }
                NavigationView{
                    Text("6")
                        .sideMenuButton(menuState: $menuOpened)
                }.navigationViewStyle(.stack)
                    .tabItem {
                        Text("3")
                    }
            }
        case .C:
            NavigationView {
                Text("C")
                    .sideMenuButton(menuState: $menuOpened)
                    
            }.navigationViewStyle(.stack)
        case .D:
            NavigationView {
                Text("D")
                    .sideMenuButton(menuState: $menuOpened)
            }.navigationViewStyle(.stack)
        }
    }
}

struct CustomSideMainView_Previews: PreviewProvider {
    static var previews: some View {
        CustomSideMainView()
    }
}

enum CustomSideMainCase: String, CaseIterable {
    case A
    case B
    case C
    case D
}
