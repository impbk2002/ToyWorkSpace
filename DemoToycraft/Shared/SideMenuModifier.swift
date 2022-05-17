//
//  SideMenuModifier.swift
//  DemoToycraft
//
//  Created by iquest1127 on 2022/05/16.
//

import Foundation
import SwiftUI

public struct SideMenu<MenuContent: View>: ViewModifier {
    @Binding var isShowing: Bool
    private let menuContent: () -> MenuContent
    
    public init(isShowing: Binding<Bool>,
         @ViewBuilder menuContent: @escaping () -> MenuContent) {
        _isShowing = isShowing
        self.menuContent = menuContent
    }
    
    public func body(content: Content) -> some View {
        let drag = DragGesture().onEnded { event in
          if event.location.x < 200 && abs(event.translation.height) < 50 && abs(event.translation.width) > 50 {
            withAnimation {
              self.isShowing = event.translation.width > 0
            }
          }
        }
        return GeometryReader { geometry in
          ZStack(alignment: .leading) {
            content
                //.disabled(isShowing)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .offset(x: self.isShowing ? geometry.size.width / 2 : 0)
            
              HStack(spacing: 0) {
                  menuContent()
                    .frame(width: geometry.size.width / 2)
                    .transition(.move(edge: .leading))
                    .offset(x: self.isShowing ? 0 : -geometry.size.width / 2)
                  if isShowing {
                      Rectangle().fill(Color(white: 1, opacity: 0.01)).onTapGesture {
                          withAnimation {
                              isShowing = false
                          }
                      }
                  }
              }
          }.gesture(drag)
        }
    }
}

public extension View {
    func sideMenu<MenuContent: View>(
        isShowing: Binding<Bool>,
        @ViewBuilder menuContent: @escaping () -> MenuContent
    ) -> some View {
        self.modifier(SideMenu(isShowing: isShowing, menuContent: menuContent))
    }
    
    func sideMenuButton(menuState:Binding<Bool>) -> some View {
        self.toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button.init("Menu") {
                    withAnimation {
                        menuState.wrappedValue.toggle()
                    }
                }
            }
        }
    }
}


class ModelObject: NSObject, ObservableObject, Identifiable {
    @Published var index:Int = 0
    override init() {
        super.init()
        print("\(self) \(#function)")
    }
    deinit {
        print("\(self) \(#function)")
    }
}

struct TabView1: View {
    @ObservedObject var viewModel:ModelObject
    var menuOpened:Binding<Bool>
    var body: some View {
        TabView(selection: $viewModel.index) {
            NavigationView{
                VStack{
                    Text("1")

                    NavigationLink("push") {
                        SingleCalendarGridView { date in
                            let formatter1:DateFormatter = {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "dd"
                                return formatter
                            }()

                            Text(date, formatter: formatter1)
                        }

                            .navigationTitle(Text("detail"))
                            
                    }
                }
                .sideMenuButton(menuState: menuOpened)

            }.navigationViewStyle(.stack)
                .tabItem {
                    Text("1")
                }.tag(0)
            NavigationView{
                Text("2")
                    .sideMenuButton(menuState: menuOpened)
            }.navigationViewStyle(.stack)
                .tabItem {
                    Text("2")
                }.tag(1)
            NavigationView{
                Text("3")
                    .sideMenuButton(menuState: menuOpened)
            }.navigationViewStyle(.stack)
                .tabItem {
                    Text("3")
                }.tag(2)
        }
    }
}
