//
//  ItemDetailCell.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 12/12/24.
//
import SwiftUI

struct ItemDetailCell: View {
    let itemName: String
    let itemDetail: String
    let itemDesc: String?
    @Binding var itemCounts: Int
    let itemImageURL: String?
    var isAddToCartButtonVisible: Bool
    var onAddToCart: () -> Void
    var onCountChanged: (Int) -> Void
    var body: some View {
        HStack(spacing: 10) {
            // Image Section
            VStack {
                AsyncImage(url: URL(string: itemImageURL ?? "")) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .cornerRadius(8)
                } placeholder: {
                    Color.gray
                        .frame(width: 150, height: 150)
                        .cornerRadius(8)
                }
                
                // Add To Cart Button / Quantity Adjuster
                VStack {
                    if isAddToCartButtonVisible {
                        Button(action: onAddToCart) {
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
                                if itemCounts > 1 {
                                    itemCounts -= 1
                                    onCountChanged(itemCounts)
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
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
    }
}
