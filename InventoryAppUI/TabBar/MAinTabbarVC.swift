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
        }
        .onAppear(){
            UITabBar.appearance().backgroundColor = UIColor(lightGreyColor)
        }
        .accentColor(lightblueColor)
    }
}

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
