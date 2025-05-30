//
//  LoginView.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 23/01/25.
//

import SwiftUI

struct LoginView: View {
    
    @State private var userName = "" //9818524882
    @State private var passWord = "" //87654321
    @State private var worngUserName = 0
    @State private var wrongPassword = 0
    @State private var showingLoginScreen = false
    @State private var isPasswordVisible: Bool = false
    let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        NavigationView {
            ZStack {
                Color.brightOrange
                    .ignoresSafeArea()
                Circle()
                    //.scale(1.7)
                    .scale(isPad ? 1.5 : 1.7)
                    .foregroundColor(.white.opacity(0.2))
                Circle()
                    //.scale(1.36)
                    .scale(isPad ? 1.2 : 1.36)
                    .foregroundColor(.white)
                    .overlay(
                        MotionAnimationView()
                            .clipShape(Circle().scale(isPad ? 4 : 2))
                    )
                VStack(alignment: .center) {
                    Spacer()
                    Image("inventory-management")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: isPad ? 200 : 80, height:  isPad ? 200 : 70)
                        .padding()
                    TextField("Enter Number", text: $userName)
                           .keyboardType(.numberPad)
                           .padding()
                           .frame(height: 50)
                           .background(Color.black.opacity(0.09))
                           .cornerRadius(10)
                           .border(.red, width: CGFloat(worngUserName))
                           .onChange(of: userName) { newValue in
                               let filtered = newValue.filter { $0.isNumber }
                               if filtered.count > 10 {
                                   userName = String(filtered.prefix(10))
                               } else {
                                   userName = filtered
                               }
                               if userName.count == 10, let first = userName.first, ["6", "7", "8", "9"].contains(first) {
                                   worngUserName = 0
                               } else {
                                   worngUserName = 2
                               }
                           }
                    
                    TextField("Enter Password",text: $passWord)
                        .padding()
                        .frame(height: 50)
                        .background(Color.black.opacity(0.09))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongPassword))
                    
                    Button(action: {
                        getlogin(username: userName, password: passWord)
                    }) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color.brightOrange)
                            .cornerRadius(10)
                    }
                    NavigationLink(
                        destination: MAinTabbarVC(),
                        isActive: $showingLoginScreen
                    ) {
                        EmptyView()
                    }
                    
                    Spacer()
                    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
                    if ApiRequest.Url.buildType == .dev {
                        Text("DEV - Version - \(appVersion)")
                            .foregroundColor(.black)
                            .padding(.bottom, isPad ? 20 : 10)
                    }
                }.padding()
            }.navigationBarHidden(true)
        } .overlay(ToastView())
    }
    
    func getlogin(username : String , password : String) {

        let parameters: [String: Any] = [
            "Password": password,
            "Mobile": username,
            "DeviceID": UIDevice.current.identifierForVendor?.uuidString ?? "",
            "FCMToken": UserDefaultsManager.shared.getFCMToken()
        ]
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getlogin,
            method: .post,
            param: parameters,
            model: GetLoginModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if let data = model.data {
                        showingLoginScreen = true
                        UserDefaultsManager.shared.setLoggedIn(true)
                        UserDefaultsManager.shared.setUserName(data.username ?? "")
                        UserDefaultsManager.shared.setEmail(data.email ?? "")
                        UserDefaultsManager.shared.setEmpCode(data.empCode ?? "")
                        ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                        print("Fetched items: \(data)")
                    } else {
                        wrongPassword = 2
                        ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                        print("No data received")
                    }
                case .failure(let error):
                    wrongPassword = 2
                    ToastManager.shared.show(message: error.localizedDescription)
                    print("API Error: \(error)")
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
