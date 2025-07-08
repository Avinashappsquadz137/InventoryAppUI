//
//  ShowScannedItemsView.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 02/07/25.
//

import SwiftUI

struct ShowScannedItemsView: View {
    
    let order: ItemDetail
    @State private var totalRent = 0
    @State private var itemPrices: [String: String] = [:]
    @State private var shouldNavigate: Bool = false
    @Environment(\.presentationMode) var presentationMode


    var isSubmitEnabled: Bool {
        let rents = order.items.map { item in
            let quantity = Int(item.quantity) ?? 0
            let price = Int(itemPrices[item.itemName] ?? "") ?? 0
            return quantity * price
        }
        
        let hasValidPrices = order.items.allSatisfy {
            if let priceString = itemPrices[$0.itemName], let price = Int(priceString) {
                return price > 0
            }
            return false
        }
        
        let total = rents.reduce(0, +)
        return hasValidPrices && total > 0
    }

    
    var body: some View {
        VStack{
            List(order.items, id: \.itemName) { item in
                ShowScannedItemsCells(textFieldValue: Binding(
                    get: { itemPrices[item.itemName] ?? "" },
                    set: { itemPrices[item.itemName] = $0 }
                ),
                itemName: item.itemName,
                itemQuantity: item.quantity,
                itemPerPrice: "\(item.amount)")
            }
            Spacer()
            NavigationLink(destination: OrderScannedItemsView(order: order ,itemPrices: itemPrices), isActive: $shouldNavigate) {
                EmptyView()
            }
            
            Button(action: {
                shouldNavigate = true
            }) {
                Text("SUBMIT")
                    .font(.headline)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(isSubmitEnabled ? Color.brightOrange : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(!isSubmitEnabled)
            .padding(16)
        }
        .overlay(ToastView())
        .navigationTitle("Item List Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
        }
    }
}


