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
    @State private var itemCheckedStates: [Bool]
    
    init(challanDetail: ChallanIDModal, isCheckboxVisible: Bool) {
        self.challanDetail = challanDetail
        _itemCheckedStates = State(initialValue: Array(repeating: false, count: challanDetail.products?.count ?? 0))
    }
    
    
    var body: some View {
        VStack {
            
            Button(action: {
                isChecked.toggle()
                itemCheckedStates = Array(repeating: isChecked, count: itemCheckedStates.count)
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
            
            if let products = challanDetail.products, !products.isEmpty {
                List(products.indices, id: \.self) { index in
                    ReturnChallanItemCell(
                        itemImageURL: products[index].iTEM_THUMBNAIL,
                        isChecked: $itemCheckedStates[index],
                        itemName: products[index].iTEM_NAME ?? "Unknown Item",
                        modelNo: products[index].mODEL_NO ?? "No Model No",
                        brand: products[index].bRAND ?? "Unknown Brand"
                    )
                    .onChange(of: itemCheckedStates[index]) { _ in
                        updateAllSelectState()
                    }
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
    private func updateAllSelectState() {
        isChecked = itemCheckedStates.allSatisfy { $0 }
    }
}
