//
//  ReturnChallanItemCell.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 15/01/25.
//

import SwiftUI

struct ReturnChallanItemCell: View {
    
    let itemImageURL: String?
    var isCheckboxVisible: Bool
    @State private var isChecked: Bool = true
    var itemName: String
    var modelNo: String
    var brand: String
    
    var body: some View {
        HStack(spacing: 10) {
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
            VStack(alignment: .leading, spacing: 5){
                
                Text(itemName)
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(.primary)
                Text(modelNo)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                Text(brand)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
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
}



//#Preview {
//    ReturnChallanItemCell(itemImageURL: "", isCheckboxVisible: true)
//}
