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
    var itemCount: Int?
    let itemImageURL: String?
    @State private var itemCounts: Int = 0
 
    @Binding var cartCount: Int
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
                
                VStack {
                    if cartCount == 0 {
                        Button(action: {
                            cartCount += 1
                        }) {
                            Text("Add To Cart")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: 150)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    } else {
                        HStack(spacing: 20) { // Adjusted spacing for better button separation
                            Button(action: {
                                if itemCounts > 0 {
                                    itemCounts -= 1
                                    print("Item count after minus: \(itemCounts)")
                                }
                            }) {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                                    .font(.system(size: 30))
                                    .padding(.leading) // Added padding to avoid interaction with other buttons
                            }
                            
                            Text("\(itemCount ?? 0)")
                                .font(.system(size: 20, weight: .semibold))
                                .frame(width: 40)
                            
                            Button(action: {
                                itemCounts += 1
                                print("Item count after plus: \(itemCounts)")
                            }) {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.green)
                                    .font(.system(size: 30))
                                    .padding(.trailing) // Added padding to avoid interaction with other buttons
                            }
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

struct ItemDetailCell_Previews: PreviewProvider {
    static var previews: some View {
        @State var cartCount: Int = 0
        ItemDetailCell(
            itemName: "Item Name",
            itemDetail: "This is a brief detail of the item.",
            itemDesc: "This is an optional description of the item.",
            itemCount: 0,
            itemImageURL: "", cartCount: .constant(cartCount)
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
