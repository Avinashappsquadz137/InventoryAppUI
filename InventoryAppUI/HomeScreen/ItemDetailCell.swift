//
//  ItemDetailCell.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 12/12/24.
//

import SwiftUI

struct ItemDetailCell: View {
    
    @State var itemName: String
    @State var itemDetail: String
    @State var itemDesc: String?
    @State var itemCount: String?
    @State var itemImage: UIImage
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(spacing: 15) {
                    VStack {
                        // Image Section
                        Image(uiImage: itemImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.2)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                        // Counter Section
                        if let count = Int(itemCount ?? "0") {
                            HStack {
                                Button(action: {
                                    if count > 0 {
                                        itemCount = String(count - 1)
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                                
                                Text(itemCount ?? "0")
                                    .font(.body)
                                    .foregroundColor(.primary)
                                
                                Button(action: {
                                    itemCount = String(count + 1)
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                        }
                    }
                    
                    // Text Details Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text(itemName)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(itemDetail)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        if let itemDesc = itemDesc {
                            Text(itemDesc)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.leading, 10)
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 10)
                .frame(width: geometry.size.width - 32)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct ItemDetailCell_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailCell(
            itemName: "Item Name",
            itemDetail: "This is a brief detail of the item.",
            itemDesc: "This is an optional description of the item.",
            itemCount: "5",
            itemImage: UIImage(systemName: "star.fill") ?? UIImage()
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
