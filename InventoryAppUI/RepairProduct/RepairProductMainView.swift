//
//  RepairProductMainView.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 27/01/25.
//

import SwiftUI

struct RepairProductMainView: View {
    
    @State private var repairListItems : [RepairList] = []
    @Environment(\.presentationMode) var presentationMode
    @State private var showingLoginScreen = false
    @State private var selectedProduct: RepairList?
    
    var body: some View {
        NavigationStack {
            VStack {
                List(repairListItems, id: \.iTEM_MASTER_ID) { product in
                    RepairProductCell(categoryName: product.iTEM_NAME ?? "",
                                      brandName: product.bRAND ?? "",
                                      modelNo: product.mODEL_NO ?? "",
                                      sLNo: product.iTEM_MASTER_ID ?? "",
                                      itemImageURL: "\(Constant.BASEURL)/\(product.iTEM_THUMBNAIL ?? "")" , onEditTapped: {
                        selectedProduct = product
                        showingLoginScreen = true
                    })
                    .listRowInsets(EdgeInsets())
                    .padding(5)
                }
                
                NavigationLink(
                    destination: AddProductRepairDetail(product: selectedProduct),
                    isActive: $showingLoginScreen
                ) {
                    EmptyView()
                }
                .onAppear {
                    getAllItemRepairList()
                }
                .modifier(ViewModifiers())
                .navigationTitle("Repair Products")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            redirectToMainTabbar()
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                        }
                    }
                }
                .overlay(ToastView())
            }
        }
    }
    
    func getAllItemRepairList() {
        var dict = [String: Any]()
        dict["emp_code"] = "1"
        ApiClient.shared.callmethodMultipart(apiendpoint: Constant.getAllItemRepairList, method: .post, param: dict, model: RepairListModel.self){ result in
            switch result {
            case .success(let model):
                if let data = model.data {
                    DispatchQueue.main.async {
                        repairListItems = data
                    }
                    print("Fetched items: \(data)")
                } else {
                    print("No data received")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func redirectToMainTabbar() {
        DispatchQueue.main.async {
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: MAinTabbarVC())
                window.makeKeyAndVisible()
            }
        }
    }
}
