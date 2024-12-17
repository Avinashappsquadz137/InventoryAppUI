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
    @State private var showPopup = false
    
    var body: some View {
        //        ZStack
        ZStack {
            VStack {
                if isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else {
                    List(items, id: \.id) { item in
                        ItemDetailCell(
                            itemMasterId: item.iTEM_MASTER_ID,
                            itemName: item.iTEM_NAME ?? "Unknown",
                            itemDetail: "Brand: \(item.bRAND ?? "Unknown"), Model: \(item.mODEL_NO ?? "Unknown")",
                            itemDesc: item.sR_NUMBER ?? "N/A",
                            itemCounts: .constant(item.items_in_cart ?? 1),
                            isAddToCartButtonVisible: .constant(item.items_in_cart ?? 1),
                            isCheckboxVisible: true,
                            itemImageURL: item.iTEM_THUMBNAIL ?? "",
                            onAddToCart: {},
                            onCountChanged: { _ in }
                        )
                        .listRowInsets(EdgeInsets())
                        .padding(.vertical, 5)
                    }
                    .listStyle(PlainListStyle())
                }
                
                HStack {
                    Button(action: {
                        showPopup = true
                    }) {
                        Text("Continue")
                    }
                    .font(.headline)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(5)
            }
            .onAppear {
                getMemberDetail()
            }
            if showPopup {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showPopup = false
                        }
                    SelectDatePopUp(showPopup: $showPopup)
                }
                .transition(.opacity) 
                .animation(.easeInOut, value: showPopup)
            }
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
