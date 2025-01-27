//
//  SideMenuView.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 30/12/24.
//

import SwiftUI

struct SideMenu: View {
    @Binding var isShowing: Bool
    var content: AnyView
    var edgeTransition: AnyTransition = .move(edge: .leading)
    var body: some View {
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                content
                    .transition(edgeTransition)
                    .background(
                        Color.clear
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
}

enum SideMenuRowType: Int, CaseIterable{
    case home = 0
    case favorite
    case chat
    case profile
    case repairProduct
    case privacyPolicy
    case logOut
    
    var title: String{
        switch self {
        case .home:
            return "HOME"
        case .favorite:
            return "FAVOURITE"
        case .chat:
            return "CARTS"
        case .profile:
            return "SAVED"
        case .repairProduct:
            return "REPAIR PRODUCT"
        case .privacyPolicy:
            return "PRIVACY & POLICY"
        case .logOut :
            return "LOG OUT"
        }
    }
    
    var iconName: String{
        switch self {
        case .home:
            return "ic_home"
        case .favorite:
            return "ic_favourite_tabbar"
        case .chat:
            return "cart"
        case .profile:
            return "saved"
        case .repairProduct:
            return "imgrepair_Product"
        case .privacyPolicy:
            return "ImgPrivacyPolicy"
        case .logOut:
            return "imgLogOut"
        }
    }
}


struct SideMenuView: View {
    
    @Binding var selectedSideMenuTab: Int
    @Binding var presentSideMenu: Bool
    @State private var isSubMenuVisible: Bool = false
    @State private var showWebView: Bool = false
    @State private var showLogoutAlert: Bool = false
    let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    
    var body: some View {
        HStack {
            
            ZStack{
                Rectangle()
                    .fill(.white)
                    .frame(width: 270)
                    .shadow(color: .blue.opacity(0.1), radius: 5, x: 0, y: 3)
                
                VStack(alignment: .leading, spacing: 0) {
                    ProfileImageView()
                        .frame(height: isPad ? 250 : 140)
                        .padding(.bottom, isPad ? 60 : 30)
                    ScrollView {
                        ForEach(SideMenuRowType.allCases, id: \.self){ row in
                            RowView(isSelected: selectedSideMenuTab == row.rawValue, imageName: row.iconName, title: row.title){
                                 if  row == .logOut {
                                     showLogoutAlert = true
                                }else if row == .privacyPolicy {
                                    //showWebView = true
                                    if let url = URL(string: "https://github.com/Avinashgupta137") {
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                    }
                                } else {
                                    selectedSideMenuTab = row.rawValue
                                    isSubMenuVisible = false // Hide submenu if another row is selected
                                    presentSideMenu.toggle()
                                }
                            }
//                            if row == .dateSelect && isSubMenuVisible {
//                                SubMenuView()
//                                    .padding(.leading, 40) // Indent submenu
//                            }
                        }
                        
                        Spacer()
                    }
                }
                .padding(.top, isPad ? 150 : 100)
                .frame(width: isPad ? 400 : 270)
                .background(
                    Color.white
                )
            }
            Spacer()
        }
        .background(.clear)
        .alert(isPresented: $showLogoutAlert) { // Logout confirmation alert
            Alert(
                title: Text("Are you sure?"),
                message: Text("Do you really want to log out?"),
                primaryButton: .destructive(Text("Log Out")) {
                    logout()
                },
                secondaryButton: .cancel()
            )
        }
        //        .navigationTitle("")
//        .navigationBarHidden(true)
//        .sheet(isPresented: $showWebView) { // Present WebView as a sheet
//            WebView(url: URL(string: "https://github.com/Avinashgupta137")!)
//                .navigationTitle("Privacy & Policy")
//        }
    }
    
    func ProfileImageView() -> some View{
        VStack(alignment: .center){
            HStack{
                Spacer()
                Image("inventory-management")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: isPad ? 200 : 100, height:  isPad ? 200 : 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: isPad ? 100 : 50)
                            .stroke(.green.opacity(0.5), lineWidth: isPad ? 20 : 10)
                    )
                    .cornerRadius(isPad ? 100 : 50)
                Spacer()
            }
            
            Text("AVINASH GUPTA")
                .font(.system(size: isPad ? 24 : 18, weight: .bold))
                .foregroundColor(.black)
            
            Text("IOS Developer")
                .font(.system(size: isPad ? 18 : 14, weight: .semibold))
                .foregroundColor(.black.opacity(0.5))
        }
    }
    func SubMenuView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Button("Sub Option 1") {
                print("Sub Option 1 selected")
            }
            .padding(.vertical, 10)
            
            Button("Sub Option 2") {
                print("Sub Option 2 selected")
            }
            .padding(.vertical, 10)
        }
        .font(.system(size: 14))
        .foregroundColor(.black)
    }
    func RowView(isSelected: Bool, imageName: String, title: String, hideDivider: Bool = false, action: @escaping (()->())) -> some View{
        Button{
            action()
        } label: {
            VStack(alignment: .leading){
                HStack(spacing: 20){
                    Rectangle()
                        .fill(isSelected ? .blue : .white)
                        .frame(width: 5)
                    
                    ZStack{
                        Image(imageName)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(isSelected ? .black : .gray)
                            .frame(width: 26, height: 26)
                    }
                    .frame(width: 30, height: 30)
                    Text(title)
                        .font(.system(size: isPad ? 18 : 14, weight: .semibold))
                        .foregroundColor(isSelected ? .black : .gray)
                    Spacer()
                }
            }
        }
        .frame(height: 50)
        .background(
            LinearGradient(colors: [isSelected ? .blue.opacity(0.5) : .white, .white], startPoint: .leading, endPoint: .trailing)
        )
    }
    func logout() {
        UserDefaultsManager.shared.setLoggedIn(false)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: LoginView())
                window.makeKeyAndVisible()
            }
        }
    }
}
