//
//  ItemDetailCell.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 12/12/24.
//
import SwiftUI

struct ItemDetailCell: View {
    let itemMasterId: String?
    let itemName: String
    let itemDetail: String
    let itemDesc: String?
    @Binding var itemCounts: Int // Binding for item count
    @Binding var isAddToCartButtonVisible: Int // Binding for "Add to Cart" button visibility
    @State private var isChecked: Bool = true
    var isCheckboxVisible: Bool
    
    let itemImageURL: String?
    var onAddToCart: () -> Void
    var onCountChanged: (Int) -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            // Image Section
            VStack {
                AsyncImage(url: URL(string: itemImageURL ?? "")) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 150)
                        .cornerRadius(8)
                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 150)
                        .foregroundColor(.gray)
                        .cornerRadius(8)
                }
                
                // Add To Cart Button / Quantity Adjuster
                VStack {
                    if isAddToCartButtonVisible == 0 {
                        Button(action: {
                            onAddToCart()
                            addRemoveData()
                            isAddToCartButtonVisible = 1
                            itemCounts = 1
                        }) {
                            Text("Add To Cart")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: 150)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        HStack(spacing: 20) {
                            Button(action: {
                                if itemCounts > 0 {
                                    itemCounts -= 1
                                    addRemoveData()
                                    onCountChanged(itemCounts)
                                    
                                }
                                if itemCounts == 0 {
                                    isAddToCartButtonVisible = 0
                                }
                            }) {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                                    .font(.system(size: 30))
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Text("\(itemCounts)")
                                .font(.system(size: 20, weight: .semibold))
                                .frame(width: 40)
                            
                            Button(action: {
                                itemCounts += 1
                                addRemoveData()
                                onCountChanged(itemCounts)
                            }) {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.green)
                                    .font(.system(size: 30))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.top, 5)
                    }
                }
            }
            
            // Details Section
            VStack(alignment: .leading, spacing: 10) {
                Text(itemName)
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(.primary)
                Text(itemDetail)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                
                if let itemDesc = itemDesc {
                    Text(itemDesc)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            if isCheckboxVisible {
                Button(action: {
                    isChecked.toggle()
                    print("Checkbox tapped: \(isChecked ? "Checked" : "Unchecked")")
                }) {
                    Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 30))
                        .foregroundColor(isChecked ? .green : .gray)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
    }
    
    func addRemoveData() {
        let parameters: [String: Any] = [
            "emp_code": "1",
            "ITEM_NAME" : "\(itemMasterId ?? "")",
            "items_in_cart": "\(itemCounts)"
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
