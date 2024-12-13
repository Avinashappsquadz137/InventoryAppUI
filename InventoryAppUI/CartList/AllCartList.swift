//
//  AllCartList.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 13/12/24.
//

import SwiftUI

struct AllCartList: View {
    
    @State private var items: [CartList] = []
    @State private var isLoading = true
    @State private var addedToCart: [Bool] = []
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
                    .padding()
            } else {
                List(items, id: \.id) { item in
                    ItemDetailCell(
                        itemName: item.iTEM_NAME ?? "Unknown",
                        itemDetail: "Brand: \(item.bRAND ?? "Unknown"), Model: \(item.mODEL_NO ?? "Unknown")",
                        itemDesc: item.sR_NUMBER ?? "N/A",
                        itemCount: item.items_in_cart,
                        itemImageURL: item.iTEM_THUMBNAIL ?? "",
                        isAddToCartButtonVisible: false, onAddToCart: {},
                        onCountChanged: {_ in 
//                                                    addedToCart[index] = true // Mark the item as added to cart
//                                                    print("Added to cart: \(items[index].iTEM_NAME ?? "Unknown")")
                                                }
                    )
                    .listRowInsets(EdgeInsets())
                    .padding(.vertical, 5) // Add custom padding
                }
                .listStyle(PlainListStyle()) // Optional: Use plain style for better visuals
            }
        }
        .onAppear {
            getMemberDetail()
        }
    }
    
    func getMemberDetail() {
        let parameters: [String: Any] = ["emp_code": "1"]
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.allcartlist,
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

#Preview {
    AllCartList()
}
