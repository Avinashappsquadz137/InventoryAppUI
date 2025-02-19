//
//  InventoryAppUIApp.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 12/12/24.
//

import SwiftUI
import Firebase
import UserNotifications
import FirebaseMessaging
import FirebaseCore
import IQKeyboardManagerSwift

@main
struct InventoryAppUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            scene.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            SplashView()
                .navigationViewStyle(StackNavigationViewStyle())
                .environment(\.colorScheme, .light)
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
    
    let gcmMessageIDKey = "AIzaSyCrCt043HGB2f6DitISAWE1Gy-qYq4jGSs"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        IQKeyboardManager.shared.resignOnTouchOutside = true
        UNUserNotificationCenter.current().delegate = self
       
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions
        ) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }

        application.registerForRemoteNotifications()


        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM token: \(error)")
            } else if let token = token {
                print("FCM Token: \(token)")
                UserDefaultsManager.shared.setFCMToken(token)
            }
        }

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
      -> UIBackgroundFetchResult {
      
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      print(userInfo)

      return UIBackgroundFetchResult.newData
    }
}
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else {
            print("FCM Token is nil")
            return
        }
        UserDefaultsManager.shared.setFCMToken(fcmToken)
        print("FCM Token: \(fcmToken)")

    }
}
extension AppDelegate: UNUserNotificationCenterDelegate {

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
    let userInfo = notification.request.content.userInfo

    print("📩 Foreground Notification Data: \(userInfo)")

    return [.alert, .sound, .badge]
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse) async {
    let userInfo = response.notification.request.content.userInfo

    print("📩 User tapped notification: \(userInfo)")
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
                    .navigationViewStyle(StackNavigationViewStyle())
                    .environment(\.colorScheme, .light)
            } else {
                LoginView()
                    .navigationViewStyle(StackNavigationViewStyle())
                    .environment(\.colorScheme, .light)
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
