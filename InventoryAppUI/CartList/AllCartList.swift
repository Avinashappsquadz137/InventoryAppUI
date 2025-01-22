//
//  AllCartList.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 13/12/24.
//

import SwiftUI
import VisionKit

struct AllCartList: View {
    
    @State private var items: [CartList] = []
    @State private var isLoading = true
    @State private var checkedStates: [String] = []
    @State private var value: Int = 0
    @State private var allCartList: GetAllCartList? = nil
    
    @State private var showDateilScreen = false
    
    @State private var itemToDelete: CartList? = nil
    @State private var showDeleteConfirmation: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if isLoading {
                        ProgressView("Loading...")
                            .padding()
                    } else {
                        if let toDate = allCartList?.to_date, let fromDate = allCartList?.from_date {
                            HStack {
                                Text("\(fromDate)")
                                    .font(.headline)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(8)
                                Text("\(toDate)")
                                    .font(.headline)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(8)
                            }.padding(5)
                        }
                        
                        List(items, id: \.id) { item in
                            ItemDetailCell(
                                itemMasterId: item.iTEM_MASTER_ID,
                                itemName: item.iTEM_NAME ?? "Unknown",
                                itemDetail: "Brand: \(item.bRAND ?? "Unknown"), Model: \(item.mODEL_NO ?? "Unknown")",
                                itemDesc: item.currently_available,
                                itemCounts: .constant(item.items_in_cart ?? 0),
                                isAddToCartButtonVisible: .constant(item.items_in_cart ?? 0),
                                isCheckboxVisible: true,
                                itemImageURL: item.iTEM_THUMBNAIL ?? "",
                                onAddToCart: {},
                                onCountChanged: { newCount in
                                    if let itemID = item.iTEM_MASTER_ID {
                                        if item.currently_available == String(item.items_in_cart ?? 0) {
                                            let updatedCount = (item.items_in_cart ?? 0) - 1
                                            if updatedCount > 0 {
                                                updateItemCount(itemID: itemID, newCount: updatedCount)
                                            }
                                        }else {
                                            let updatedCount = (item.items_in_cart ?? 0) + value
                                            if updatedCount > 0 {
                                                updateItemCount(itemID: itemID, newCount: updatedCount)
                                            }
                                        }
                                    }
                                },
                                hideDeleteButton: false,
                                onDelete: {
                                    itemToDelete = item
                                    showDeleteConfirmation = true
                                },
                                onCheckUncheck : {
                                    if items.firstIndex(where: { $0.iTEM_MASTER_ID == item.iTEM_MASTER_ID }) != nil {
                                        if let itemId = item.iTEM_MASTER_ID {
                                            if let existingIndex = checkedStates.firstIndex(of: itemId) {
                                                checkedStates.remove(at: existingIndex)
                                            } else {
                                                checkedStates.append(itemId)
                                            }
                                            print("Selected IDs: \(checkedStates)")
                                        }
                                    }
                                }
                            )
                            .listRowInsets(EdgeInsets())
                            .padding(.vertical, 5)
                        }
                        .listStyle(PlainListStyle())
                    }
                    HStack {
                        if !items.isEmpty {
                            Button(action: {
                                showDateilScreen = true
                            }) {
                                Text("Continue")
                                    .font(.headline)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(5)
                }
            }
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Are you sure?"),
                    message: Text("Do you want to delete \(itemToDelete?.iTEM_NAME ?? "this item") from the cart?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let item = itemToDelete {
                            deleteCartItem(item: item)
                            getMemberDetail()
                        }
                    },
                    secondaryButton: .cancel {
                        itemToDelete = nil 
                    }
                )
            }

            .fullScreenCover(isPresented: $showDateilScreen) {
                CreateChallanDetails(checkedStates: checkedStates)
            }
        }
        .onAppear {
            getMemberDetail()
        }
        .onReceive(NotificationCenter.default.publisher(for: .updateValueNotification)) { notification in
            if let newValue = notification.userInfo?["value"] as? Int {
                self.value = newValue
            }
        }
    }
    
    func deleteCartItem(item: CartList) {
        let parameters: [String: Any] = [
            "emp_code": "1",
            "product_id": "\(item.iTEM_MASTER_ID ?? "")"
        ]

        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.deleteCartItem,
            method: .post,
            param: parameters,
            model: RemoveData.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if (model.data != nil) { // Check API response success
                        ToastManager.shared.show(message: model.message ?? "Item deleted successfully")
                        if let index = items.firstIndex(where: { $0.id == item.id }) {
                            items.remove(at: index) // Remove item locally
                        }
                    } else {
                        ToastManager.shared.show(message: model.message ?? "Failed to delete item")
                    }
                case .failure(let error):
                    print("API Error: \(error)")
                    ToastManager.shared.show(message: "Error deleting item")
                }
                itemToDelete = nil // Reset the deletion state
            }
        }
    }

    func getMemberDetail() {
        let parameters: [String: Any] = ["emp_code": "1"]
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.allcartlistByDate,
            method: .post,
            param: parameters,
            model: GetAllCartList.self
        ) { result in
            DispatchQueue.main.async {
                isLoading = false
                
                switch result {
                case .success(let model):
                    if let data = model.data {
                        self.items = data
                        self.checkedStates = data.compactMap { $0.iTEM_MASTER_ID }
                        self.allCartList = model
                        print("Fetched items: \(data)")
                    } else {
                        print("No data received")
                    }
                case .failure(let error):
                    self.items = []
                    print("API Error: \(error)")
                }
            }
        }
    }
    
    func updateItemCount(itemID: String, newCount: Int) {
        if let index = items.firstIndex(where: { $0.iTEM_MASTER_ID == itemID }) {
            items[index].items_in_cart = newCount
        }
        let toDate = allCartList?.to_date
        let fromDate = allCartList?.from_date
        let parameters: [String: Any] = [
            "emp_code": "1",
            "ITEM_NAME" : itemID,
            "items_in_cart": "\(newCount)",
            "to_date": toDate ?? "",
            "from_date" : fromDate ?? ""
        ]
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.addtocart,
            method: .post,
            param: parameters,
            model: AddRemoveData.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if let data = model.data {
                        print("Fetched items: \(data)")
                    } else {
                        print("No data received")
                    }
                case .failure(let error):
                    print("API Error: \(error)")
                }
            }
        }
    }
    
}
