//
//  ReturnChallanItemView.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 15/01/25.
//

import SwiftUI

struct ReturnChallanItemView: View {
    var challanDetail: ChallanIDModal
    @State private var isChecked = false
    var isCheckboxVisible: Bool
    
    var body: some View {
        VStack {
                if isCheckboxVisible {
                    Button(action: {
                        isChecked.toggle()
                        print("Checkbox tapped: \(isChecked ? "Checked" : "Unchecked")")
                    }) {
                        HStack(){
                            Spacer()
                            Text("ALL SELECT")
                                .font(.headline)
                            Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 30))
                                .foregroundColor(isChecked ? .green : .gray)
                        }
                        .padding(5)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            if let products = challanDetail.products, !products.isEmpty {
                List(products) { item in
                    ReturnChallanItemCell(
                        itemImageURL: item.iTEM_THUMBNAIL,
                        isCheckboxVisible: true,
                        itemName: item.iTEM_NAME ?? "Unknown Item",
                        modelNo: item.mODEL_NO ?? "No Model No",
                        brand: item.bRAND ?? "Unknown Brand"
                    )
                    .listRowInsets(EdgeInsets())
                    .padding(10)
                }
                .listStyle(PlainListStyle())
            }
            Button(action: {
               
            }) {
                Text("Next")
                    .font(.headline)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

        }
        .padding(10)
    }
}
