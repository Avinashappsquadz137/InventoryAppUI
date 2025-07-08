//
//  ShowScannedItemsCells.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 02/07/25.
//

import SwiftUI
import VisionKit

struct ShowScannedItemsCells: View {
    
    @Binding var textFieldValue: String
    @State var itemName: String
    @State var itemQuantity: String
    @State var itemPerPrice: String
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(itemName)")
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("Max Quantity :\(itemQuantity)")
                        .font(.callout)
                    let itemTotalRent = (Int(itemQuantity) ?? 0) * (Int(textFieldValue) ?? 0)
                    Text("Total Rent: \(itemTotalRent)")
                        .font(.callout)
//                    Text("Per Pices Rent : \(itemPerPrice)")
//                        .font(.callout)
                }
                Spacer()
            }
            VStack {
                HStack {
                    TextField("Rent Per Items", text: $textFieldValue)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
        .onAppear {
            if textFieldValue.isEmpty {
                textFieldValue = itemPerPrice
            }
        }
    }
}
