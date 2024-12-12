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
                title: "Dashboard",
                leftButtonImage: "gearshape",
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
                }.tag(1)
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
            // Left Button
            Button(action: leftButtonAction) {
                Image(systemName: leftButtonImage)
                    .font(.system(size: 24, weight: .regular))
            }
            .accentColor(.blue)
            
            Spacer()
            
            // Title
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
            
            Spacer()
            
            // Right Button
            Button(action: rightButtonAction) {
                Image(systemName: rightButtonImage)
                    .font(.system(size: 24, weight: .regular))
            }
            .accentColor(.blue)
        }
        .padding(16)
        .background(Color.white) // Add background color if needed
        .shadow(radius: 10) // Optional: add shadow for better visual appearance
    }
}
