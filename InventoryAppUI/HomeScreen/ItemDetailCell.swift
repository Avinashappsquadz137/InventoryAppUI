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
    let itemCount: String?
    let itemImageURL: String?
    
    var body: some View {
        HStack(spacing: 10) {
            // Image Section
            VStack(){
                AsyncImage(url: URL(string: itemImageURL ?? "")) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .cornerRadius(8)
                } placeholder: {
                    lightGreyColor
                        .frame(width: 150, height: 150)
                        .cornerRadius(8)
                }
                if let count = Int(itemCount ?? "0") {
                    HStack(spacing: 5) {
                        Button(action: {}) {
                            Image(systemName: "minus.circle")
                                .foregroundColor(.red)
                                .font(.system(size: 30))
                        }
                        
                        Text("\(count)")
                            .font(.system(size: 20, weight: .semibold))
                            .frame(width: 40)
                        
                        
                        Button(action: {}) {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.green)
                                .font(.system(size: 30))
                        }
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

            Spacer() // Push content to the left

            // Counter Section
          
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
    }
}



struct ItemDetailCell_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailCell(
            itemName: "Item Name",
            itemDetail: "This is a brief detail of the item.",
            itemDesc: "This is an optional description of the item.",
            itemCount: "0",
            itemImageURL: ""
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
