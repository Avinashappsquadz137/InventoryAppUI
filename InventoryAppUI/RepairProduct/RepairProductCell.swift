//
//  RepairProductCell.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 28/01/25.
//

import SwiftUI

struct RepairProductCell: View {
    let categoryName: String
    let brandName: String
    let modelNo: String
    let sLNo: String
    let itemImageURL : String
    
    let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    let onEditTapped: () -> Void
    let onEyeTapped: () -> Void
    
    var body: some View {
        HStack {
            VStack {
                AsyncImage(url: URL(string: itemImageURL)) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(
                            width: isPad ? 300 : 150,
                            height: isPad ? 300 : 150
                        )
                        .cornerRadius(8)
                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: isPad ? 300 : 150,
                            height: isPad ? 300 : 150
                        )
                        .foregroundColor(.gray)
                        .cornerRadius(8)
                }
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("\(categoryName)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                Text("\(brandName)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                Text("Model No: \(modelNo)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.primary)
                Text("SL No: \(sLNo)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.primary)
            }
            .padding(.leading, 10)
            Spacer()
            VStack(spacing : 20){
                Button(action: {
                    onEditTapped()
                }) {
                    Image(systemName: "pencil")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: onEyeTapped) {
                    Image(systemName: "eye")
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(10)
        //        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white).shadow(radius: 5))
    }
}
struct RepairProductCell_Previews: PreviewProvider {
    static var previews: some View {
        RepairProductCell(
            categoryName: "Laptop",
            brandName: "Apple",
            modelNo: "MacBook Pro 16\"",
            sLNo: "ABC123456",
            itemImageURL: "https://via.placeholder.com/150",
            onEditTapped: { print("Edit tapped") }, onEyeTapped: { print("Eye tapped") }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
