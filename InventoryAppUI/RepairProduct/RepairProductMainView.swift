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
    @Environment(\.dismiss) private var dismiss
    @State private var showingLoginScreen = false
    @State private var selectedProduct: RepairList?
    @State private var expandedCells: Set<String> = []
    
    var body: some View {
        NavigationStack {
            VStack {
                List(repairListItems, id: \.iTEM_MASTER_ID) { product in
                    RepairProductCell(categoryName: product.iTEM_NAME ?? "",
                                      brandName: product.bRAND ?? "",
                                      modelNo: product.mODEL_NO ?? "",
                                      sLNo: product.iTEM_MASTER_ID ?? "",
                                      itemImageURL: "\(Constant.BASEURL)/\(product.iTEM_THUMBNAIL ?? "")",
                                      repairStatus: product.rEPAIR_STATUS ?? "" , onEditTapped: {
                        selectedProduct = product
                        showingLoginScreen = true
                    },
                        onEyeTapped: {
                        toggleExpansion(for: product.iTEM_MASTER_ID ?? "")
                    })
                    if expandedCells.contains(product.iTEM_MASTER_ID ?? "") {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("More Details:")
                                .font(.headline)
                            Text("Price: ₹\(product.iTEM_MASTER_ID ?? "N/A")")
                            Text("Repair Date: \(product.bRAND ?? "N/A")")
                            Text("Remarks: \(product.iTEM_NAME ?? "N/A")")
                            
                            Button(action: {
                                readyForItemAvailable(repairID: product.iTEM_REPAIR_ID ?? "",
                                                      itemID: product.iTEM_MASTER_ID ?? "")
                            }) {
                                Text("Confirm Availability")
                                    .font(.system(size: 14, weight: .bold))
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.brightOrange)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .transition(.opacity)
                    }
                }
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
                        dismiss()
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
    
    func toggleExpansion(for id: String) {
        if expandedCells.contains(id) {
            expandedCells.remove(id)
        } else {
            expandedCells.insert(id)
        }
    }
    
    
    func readyForItemAvailable(repairID : String ,itemID : String) {
        var dict = [String: Any]()
        dict["emp_code"] = "1"
        dict["repair_id"] = repairID
        dict["item_id"] = itemID
        
        ApiClient.shared.callmethodMultipart(apiendpoint: Constant.readyForItemAvailable, method: .post, param: dict, model: RepairListModel.self){ result in
            switch result {
            case .success(let model):
                if let data = model.data {
                    DispatchQueue.main.async {
                        
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
                window.rootViewController = UIHostingController(rootView: MAinTabbarVC().environment(\.colorScheme, .light))
                window.makeKeyAndVisible()
            }
        }
    }
}
