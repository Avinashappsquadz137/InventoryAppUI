//
//  MAinTabbarVC.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 12/12/24.
//

import SwiftUI
import VisionKit

struct MAinTabbarVC: View {
    @State var presentSideMenu = false
    @State private var selectedView = 0
    @State private var navigationTitle = "HOME"
    @State var isShowingScanner = false
    @State private var scannedText = ""
    @State private var isShowingUploadPopup = false

    var body: some View {
        ZStack(){
            
            
            VStack(){
                NavBar(
                    title: navigationTitle,
                    leftButtonImage: "line.3.horizontal",
                    leftButtonAction: { print("line.3.horizontal") },
//                    rightButtonImage: selectedView == 0 ? "bell" : nil,
//                    rightButtonAction: {
//                        if selectedView == 0 {
//                            print("Notification is Not available")
//                        }
//                    },
                  //  badgeCount: 312,
                    presentSideMenu: $presentSideMenu,
                    trailingButtonImage: selectedView == 2 ? "qrcode.viewfinder" : nil,
                    trailingButtonAction: {
                        if selectedView == 2 {
                            if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
                                isShowingScanner = true
                                print("Scanner available")
                            } else {
                                print("Scanner is not supported or available")
                            }
                        }
                    },
                    extraButtonImage: selectedView == 0 ? "plus" : nil,
                        extraButtonAction: {
                            if selectedView == 0 {
                                isShowingUploadPopup = true
                            }
                            print("Plus button tapped")
                    }
                )
                Spacer()
                TabView(selection: $selectedView) {
                    
                    NavigationView {
                        MainViewItemByDateView()
                            .onAppear {
                                navigationTitle = "HOME"
                            }
                    }
                    .tabItem {
                        Image.init("ic_home", tintColor: .clear)
                        Text("HOME")
                    }.tag(0)
                    
                    NavigationView {
                        SubmitChallanView()
                            .onAppear {
                                navigationTitle = "SUBMIT"
                            }
                    }
                    .tabItem {
                        Image.init("ic_favourite_tabbar", tintColor: .clear)
                        Text("SUBMIT")
                    }.tag(1)
                    
                    NavigationView {
                        AllCartList()
                            .onAppear {
                                navigationTitle = "CARTS"
                            }
                    }
                    .tabItem {
                        Image.init("cart", tintColor: .clear)
                        Text("CARTS")
                    }.tag(2)
                    
                    NavigationView {
                        OrderView()
                            .onAppear {
                                navigationTitle = "ORDERS"
                            }
                    }
                    .tabItem {
                        Image.init("saved", tintColor: .clear)
                        Text("ORDERS")
                    }.tag(3)
                    NavigationView {
                        ReturnChallanView()
                            .onAppear {
                                navigationTitle = "RETURN CHALLAN"
                            }
                    }
                    .tabItem {
                        Image.init("ic_controls", tintColor: .clear)
                        Text("RETURN")
                    }.tag(5)
                    
                }
                .onAppear(){
                    UITabBar.appearance().backgroundColor = UIColor(.brightOrange)
                }
                .accentColor(.white)
            }
            SideMenu(isShowing: $presentSideMenu, content: AnyView(SideMenuView(selectedSideMenuTab: $selectedView, presentSideMenu: $presentSideMenu)))
        }
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = UIColor(Color.brightOrange)
            let itemAppearance = UITabBarItemAppearance()
            itemAppearance.normal.iconColor = .black
            itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black]
            itemAppearance.selected.iconColor = .white
            itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
            tabBarAppearance.stackedLayoutAppearance = itemAppearance
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        .sheet(isPresented: $isShowingUploadPopup) {
            UploadDocumentView()
        }
        .fullScreenCover(isPresented: $isShowingScanner) {
            QRScannerView(isShowingScanner: $isShowingScanner, scannedText: $scannedText)
        }
        .navigationBarBackButtonHidden(true)
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
struct NavBar: View {
    
    var title: String
    var leftButtonImage: String
    var leftButtonAction: () -> Void
    var rightButtonImage: String?
    var rightButtonAction: (() -> Void)?
    var badgeCount: Int = 0
    @Binding var presentSideMenu: Bool
    var trailingButtonImage: String?
    var trailingButtonAction: (() -> Void)?
    var extraButtonImage: String?
    var extraButtonAction: (() -> Void)?

    var body: some View {
        HStack {
            Button(action: {
                
                presentSideMenu.toggle()
                leftButtonAction()
            }) {
                Image(systemName: leftButtonImage)
                    .font(.system(size: 30, weight: .regular))
            }
            .accentColor(.black)
            Spacer()
            Text(title)
                .font(.system(size: 24, weight: .bold))
          
            Spacer()
            if let trailingImage = trailingButtonImage, let trailingAction = trailingButtonAction {
                Button(action: trailingAction) {
                    Image(systemName: trailingImage)
                        .font(.system(size: 30, weight: .regular))
                }
                .accentColor(.black)
            }
//            if let rightImage = rightButtonImage, let rightAction = rightButtonAction {
//                Button(action: rightAction) {
//                    ZStack {
//                        Image(systemName: rightImage)
//                            .font(.system(size: 30, weight: .regular))
//                        if badgeCount > 0 {
//                            Text(badgeCount > 99 ? "+99" : "\(badgeCount)")
//                                .font(badgeCount < 100 ? .caption : .system(size: 10))
//                                .bold()
//                                .foregroundColor(.white)
//                                .frame(width: 25, height: 25)
//                                .background(Color.red)
//                                .clipShape(Circle())
//                                .offset(x: 10, y: -10)
//                        }
//                    }
//                }
//                .accentColor(.black)
//            }
            if let extraImage = extraButtonImage, let extraAction = extraButtonAction {
                Button(action: extraAction) {
                    Image(systemName: extraImage)
                        .font(.system(size: 24, weight: .regular))
                }
                .accentColor(.black)
            }

        }
        .padding(16)
        .background(Color.brightOrange)
        .shadow(radius: 10)
    }
}
