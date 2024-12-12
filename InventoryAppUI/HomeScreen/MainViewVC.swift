//
//  MainViewVC.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 12/12/24.
//

import SwiftUI

struct MainViewVC: View {
    @State private var items: [Datas] = [] // Replace `Datas` with your data model
    @State private var isLoading = true
    
    var body: some View {
       
            VStack {
                if isLoading {
                    ProgressView("Loading...")
                        .padding()
                }  else {
                    List(items, id: \.iTEM_MASTER_ID) { item in
                        ItemDetailCell(
                            itemName: item.iTEM_NAME ?? "Unknown",
                            itemDetail: "Brand: \(item.bRAND ?? "Unknown"), Model: \(item.mODEL_NO ?? "Unknown")",
                            itemDesc: item.sR_NUMBER,
                            itemCount: "\(item.items_in_cart ?? 0)",
                            itemImageURL: item.iTEM_THUMBNAIL
                        )
                        .listRowInsets(EdgeInsets()) // Remove default padding
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

