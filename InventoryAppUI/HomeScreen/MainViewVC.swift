//
//  MainViewVC.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 12/12/24.
//
import SwiftUI

struct MainViewVC: View {
    @State private var items: [Datas] = []
    @State private var isLoading = true
    @State private var addedToCart: [Bool] = [] // Track "Add to Cart" state for each item
    @State private var itemCounts: [Int] = []  // Track counts for each item
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
                    .padding()
            } else {
                List(items.indices, id: \.self) { index in
                    ItemDetailCell(
                        itemMasterId: items[index].iTEM_MASTER_ID,
                        itemName: items[index].iTEM_NAME ?? "Unknown",
                        itemDetail: "Brand: \(items[index].bRAND ?? "Unknown"), Model: \(items[index].mODEL_NO ?? "Unknown")",
                        itemDesc: items[index].sR_NUMBER,
                        itemCounts: $itemCounts[index], // Pass as binding
                        isAddToCartButtonVisible: Binding(
                            get: { items[index].items_in_cart ?? 0 },
                            set: { items[index].items_in_cart = $0 }),
                        isCheckboxVisible: false,
                        itemImageURL: items[index].iTEM_THUMBNAIL,
                        onAddToCart: {
                            addedToCart[index] = true
                            print("Added to cart: \(items[index].iTEM_NAME ?? "Unknown")")
                        },
                        onCountChanged: { newCount in
                            itemCounts[index] = newCount
                            print("Updated count for \(items[index].iTEM_NAME ?? "Unknown"): \(newCount)")
                        }
                    )
                    .listRowInsets(EdgeInsets())
                    .padding(.vertical, 5)
                }

                .listStyle(PlainListStyle())
            }
        }
        .onAppear {
            getMemberDetail()
        }
    }
    
    func getMemberDetail() {
        let parameters: [String: Any] = ["emp_code": "SANS-00290"]
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getAllItem,
            method: .post,
            param: parameters,
            model: GetAllItem.self
        ) { result in
            DispatchQueue.main.async {
                isLoading = false
                
                switch result {
                case .success(let model):
                    if let data = model.data {
                        self.items = data
                        self.addedToCart = Array(repeating: false, count: data.count)
                        self.itemCounts = Array(repeating: 1, count: data.count) // Initialize with 1
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
