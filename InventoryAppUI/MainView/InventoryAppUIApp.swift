//
//  InventoryAppUIApp.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 12/12/24.
//

import SwiftUI

@main
struct InventoryAppUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            SplashView()
            
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}


struct SplashView: View {
    let isLoggedIn = UserDefaultsManager.shared.isLoggedIn()
    @State private var isActive = false
    var body: some View {
        if isActive {
            if isLoggedIn {
                MAinTabbarVC()
                    .overlay(ToastView())
            } else {
                LoginView()
            }
        } else {
            ZStack {
                Color.white.ignoresSafeArea()
                Image("inventory-management")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}
