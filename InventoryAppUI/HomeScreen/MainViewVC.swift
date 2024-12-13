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
    @State private var addedToCart: [Bool] = [] // Track the "Add to Cart" state for each item
    @State private var itemCounts: [Int] = [] // Track counts for each item
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
                    .padding()
            } else {
                List(items.indices, id: \.self) { index in
                    ItemDetailCell(
                        itemName: items[index].iTEM_NAME ?? "Unknown",
                        itemDetail: "Brand: \(items[index].bRAND ?? "Unknown"), Model: \(items[index].mODEL_NO ?? "Unknown")",
                        itemDesc: items[index].sR_NUMBER,
                        itemCount: itemCounts[index], // Use itemCounts here
                        itemImageURL: items[index].iTEM_THUMBNAIL,
                        isAddToCartButtonVisible: !addedToCart[index],
                        onAddToCart: {
                            addedToCart[index] = true
                            print("Added to cart: \(items[index].iTEM_NAME ?? "Unknown")")
                        },
                        onCountChanged: { newCount in
                            itemCounts[index] = newCount // Update the item count
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
                        self.addedToCart = Array(repeating: false, count: data.count) // Initialize the array
                        self.itemCounts = Array(repeating: 0, count: data.count) // Initialize itemCounts array with 0
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
