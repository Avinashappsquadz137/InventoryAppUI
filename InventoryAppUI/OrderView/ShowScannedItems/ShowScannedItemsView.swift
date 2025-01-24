//
//  ShowScannedItemsView.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 11/01/25.
//

import SwiftUI

struct ShowScannedItemsView: View {
    
    let order: ItemDetail
    @Binding var textFieldValues: [String]
  
    let teamMembers: [CrewMember]
    let data: [String]
    @State private var totalRent = 0
    
    var body: some View {
        VStack{
            List(order.items, id: \.itemName) { item in
                ShowScannedItemsCells(
                    textFieldValue: "",
                    itemName: item.itemName,
                    itemQuantity: item.quantity,
                    itemCategory: item.category,
                    itemPerPrice: "",
                    onUpdateTotalRent: { rent in
                        totalRent += rent // Accumulate total rent
                    }
                )
            }
            Spacer()
            Button(action: {
                addSaveChallanmaster()
            }) {
                Text("SUBMIT")
                    .font(.headline)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(16)
        }
        .overlay(ToastView())
        .navigationTitle("Scan Items")
    }
        
        func addSaveChallanmaster() {
            var dict = [String: Any]()
            dict["challan_status"] = "0"
            dict["temp_id"] = "\(order.tempID)"
            dict["item_qr_string"] = ["1378_125_1722507307310","1409_125_1722507307380","1460_129_1722507307495","1461_129_1722507307498"]
            dict["emp_code"] = "SANS-00290"
        
            
            var rentDetails: [String: Int] = [:]
                for item in order.items {
                    let rentPerItem = Int(textFieldValues.first ?? "0") ?? 0 // Replace with actual rent per item logic
                    let quantity = Int(item.quantity) ?? 0
                    let totalRent = rentPerItem * quantity
                    rentDetails[item.itemName] = totalRent
                }

                // Convert the rentDetails dictionary to JSON string
                if let jsonData = try? JSONSerialization.data(withJSONObject: rentDetails, options: []),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    dict["RENTAMOUNT"] = "\(jsonString)"
                }
            
            for (index, field) in data.enumerated() {
                switch field {
                case "Consignee":
                    dict["consignee"] = textFieldValues[index]
                case "Transporter":
                    dict["transporter"] = textFieldValues[index]
                case "Consigner":
                    dict["consigner"] = textFieldValues[index]
                case "HSN/SAC Code":
                    dict["hsn_sac_code"] = textFieldValues[index]
                case "Eway Bill Transaction":
                    dict["eway_bill_transaction"] = textFieldValues[index]
                case "Eway Bill No":
                    dict["eway_bill_no"] = textFieldValues[index]
                case "Eway Bill Date":
                    dict["eway_bill_date"] = textFieldValues[index]
                case "Team Member":
                    dict["team_member"] = [teamMembers]
                case "Transport Id":
                    dict["transport_id"] = textFieldValues[index]

                default:
                    break
                }
            }
            print(dict)
            ApiClient.shared.callmethodMultipart(apiendpoint: Constant.addSaveChallanmaster, method: .post, param: dict, model: SaveChallanMaster.self){ result in
                switch result {
                case .success(let model):
                    if let data = model.data {
                        print("Fetched items: \(data)")
                        ToastManager.shared.show(message: model.message ?? "Success")
                    } else {
                        print("No data received")
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
}


