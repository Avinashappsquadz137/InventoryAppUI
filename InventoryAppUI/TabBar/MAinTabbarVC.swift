//
//  MAinTabbarVC.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 12/12/24.
//

import SwiftUI

struct MAinTabbarVC: View {
    
    @State private var selectedView = 0
    
    init() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack(){
            NavBar(
                title: "HOME",
                leftButtonImage: "line.3.horizontal",
                leftButtonAction: { print("Gear clicked") },
                rightButtonImage: "bell",
                rightButtonAction: { print("Bell clicked") }
            )

            Spacer()
            TabView(selection: $selectedView) {
                
                NavigationView {
                    MainViewVC()
                }
                .tabItem {
                    Image.init("ic_home", tintColor: .clear)
                    Text("HOME")
                }.tag(0)
                
                NavigationView {
                    ListView()
                        .navigationBarTitle("", displayMode: .inline)
                }
                .tabItem {
                    Image.init("ic_controls", tintColor: .clear)
                    Text("CONTROLS")
                }.tag(1)
                
                NavigationView {
                    ListView()
                        .navigationBarTitle("", displayMode: .inline)
                }
                .tabItem {
                    Image.init("ic_favourite_tabbar", tintColor: .clear)
                    Text("FAVOURITE")
                }.tag(2)
            }
            .onAppear(){
                UITabBar.appearance().backgroundColor = UIColor(lightGreyColor)
            }
            .accentColor(lightblueColor)
        }
    }}

struct TabbarVC_Previews: PreviewProvider {
    static var previews: some View {
        MAinTabbarVC()
    }
}

extension Image {
    init(_ named: String, tintColor: UIColor) {
        let uiImage = UIImage(named: named) ?? UIImage()
        let tintedImage = uiImage.withTintColor(tintColor,
                                                renderingMode: .alwaysTemplate)
        self = Image(uiImage: tintedImage)
    }
}
struct NavBar: View {
    
    var title: String
    var leftButtonImage: String
    var leftButtonAction: () -> Void
    var rightButtonImage: String
    var rightButtonAction: () -> Void
    
    var body: some View {
        HStack {
            Button(action: leftButtonAction) {
                Image(systemName: leftButtonImage)
                    .font(.system(size: 24, weight: .regular))
            }
            .accentColor(royalBlue)
            Spacer()
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color("Text_whiteBlack"))
            Spacer()
            Button(action: rightButtonAction) {
                Image(systemName: rightButtonImage)
                    .font(.system(size: 24, weight: .regular))
            }
            .accentColor(royalBlue)
        }
        .padding(16)
        .background(Color.white)
        .shadow(radius: 10)
    }
}
