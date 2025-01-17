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
    
    var body: some View {
        ZStack(){
            
            
            VStack(){
                NavBar(
                    title: navigationTitle,
                    leftButtonImage: "line.3.horizontal",
                    leftButtonAction: { print("line.3.horizontal") },
                    rightButtonImage: "bell",
                   // rightButtonAction: { print("bell clicked") },
                    presentSideMenu: $presentSideMenu,
                    trailingButtonImage: selectedView == 0 ? "qrcode.viewfinder" : nil,
                    trailingButtonAction: {
                        if selectedView == 0 {
                            if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
                                isShowingScanner = true
                                print("Scanner available")
                            } else {
                                print("Scanner is not supported or available")
                            }
                        }
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
                                navigationTitle = "FAVOURITE"
                            }
                    }
                    .tabItem {
                        Image.init("ic_favourite_tabbar", tintColor: .clear)
                        Text("FAVOURITE")
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
                                navigationTitle = "SAVED"
                            }
                    }
                    .tabItem {
                        Image.init("saved", tintColor: .clear)
                        Text("SAVED")
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
                    }.tag(4)
                }
                
                .onAppear(){
                    UITabBar.appearance().backgroundColor = UIColor(lightGreyColor)
                }
                .accentColor(lightblueColor)
            }
            SideMenu(isShowing: $presentSideMenu, content: AnyView(SideMenuView(selectedSideMenuTab: $selectedView, presentSideMenu: $presentSideMenu)))
        }
        .fullScreenCover(isPresented: $isShowingScanner) {
            QRScannerView(isShowingScanner: $isShowingScanner, scannedText: $scannedText)
        }
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
    var rightButtonImage: String
   // var rightButtonAction: () -> Void
    @Binding var presentSideMenu: Bool
    var trailingButtonImage: String?
    var trailingButtonAction: (() -> Void)?
    
    var body: some View {
        HStack {
            Button(action: {
                
                presentSideMenu.toggle()
                leftButtonAction()
            }) {
                Image(systemName: leftButtonImage)
                    .font(.system(size: 30, weight: .regular))
            }
            
            .accentColor(royalBlue)
            Spacer()
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color("Text_whiteBlack"))
            Spacer()
            if let trailingImage = trailingButtonImage, let trailingAction = trailingButtonAction {
                Button(action: trailingAction) {
                    Image(systemName: trailingImage)
                        .font(.system(size: 30, weight: .regular))
                }
                .accentColor(royalBlue)
            }
            
//            Button(action: rightButtonAction) {
//                Image(systemName: rightButtonImage)
//                    .font(.system(size: 30, weight: .regular))
//            }
//            .accentColor(royalBlue)
        }
        .padding(16)
        .background(Color.white)
        .shadow(radius: 10)
    }
}
