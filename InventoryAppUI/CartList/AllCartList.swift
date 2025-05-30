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
    @State private var isSearching = false
    @State private var searchText = ""
    private var filteredItems: [CartList] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter {
                $0.iTEM_NAME?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if isLoading {
                        ProgressView("Loading...")
                            .padding()
                    } else if items.isEmpty {
                        VStack {
                            Image(systemName: "cart.fill.badge.plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                                .padding()
                            
                            Text("No Items in Cart")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }  else {
                        if let toDate = allCartList?.to_date, let fromDate = allCartList?.from_date {
                            HStack(spacing: 10) {
                                if !isSearching {
                                    Group {
                                        Text("\(fromDate)")
                                        Text("\(toDate)")
                                    }
                                    .font(.subheadline)
                                    .padding(8)
                                    .background(Color.brightOrange.opacity(0.1))
                                    .foregroundColor(.brightOrange)
                                    .cornerRadius(8)
                                    
                                }
                                Button(action: {
                                    withAnimation {
                                        isSearching = true
                                    }
                                }) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 25))
                                        .foregroundColor(.brightOrange)
                                }
                                if isSearching {
                                    HStack(spacing: 4) {
                                        TextField("Search...", text: $searchText)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .frame(minWidth: 100)

                                        Button(action: {
                                            withAnimation {
                                                isSearching = false
                                                searchText = ""
                                            }
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.system(size: 20))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .transition(.move(edge: .trailing))
                                }

                               // Spacer()
                            }
//                            .padding(.horizontal, 10)
//                            .padding(.vertical, 5)
                        }
                        List(filteredItems, id: \.id) { item in
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
                                },
                                onCalendarTap: {},isDateSelected: false
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
                                    .background(Color.brightOrange)
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
                CreateChallanDetails(checkedStates: checkedStates).environment(\.colorScheme, .light)
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
            "emp_code": UserDefaultsManager.shared.getEmpCode(),
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
        let parameters: [String: Any] = ["emp_code": UserDefaultsManager.shared.getEmpCode()]
        
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
            "emp_code": UserDefaultsManager.shared.getEmpCode(),
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
