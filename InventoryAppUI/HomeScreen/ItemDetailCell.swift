//
//  ItemDetailCell.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 12/12/24.
//
import SwiftUI

struct ItemDetailCell: View {
    let itemMasterId: String?
    let itemName: String
    let itemDetail: String
    let itemDesc: String?
    @Binding var itemCounts: Int
    @Binding var isAddToCartButtonVisible: Int 
    @State private var isChecked: Bool = true
    var isCheckboxVisible: Bool
    let itemImageURL: String?
    var onAddToCart: () -> Void
    var onCountChanged: (Int) -> Void
    var hideDeleteButton: Bool
    var onDelete: () -> Void
    var onCheckUncheck : () -> Void
    let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    let onCalendarTap: () -> Void
    var isDateSelected: Bool
    var body: some View {
        HStack(spacing: 10) {
            VStack (alignment: .center){
                AsyncImage(url: URL(string: itemImageURL ?? "")) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(
                            maxWidth: isPad ? 300 : .infinity, 
                            maxHeight: isPad ? 300 : 150
                        )
                        .cornerRadius(8)
                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            maxWidth: isPad ? 300 : .infinity,
                            maxHeight: isPad ? 300 : 150
                        )
                        .foregroundColor(.gray)
                        .cornerRadius(8)
                }
                
                VStack {
                    if isAddToCartButtonVisible == 0 {
                        Button(action: {
                            if !isDateSelected {
                                onCalendarTap()
                                return
                            }
                            onAddToCart()
                            addRemoveData()
                            isAddToCartButtonVisible = 1
                            itemCounts = 1
                        }) {
                            Text("Add To Cart")
                                .font(.headline)
                                .padding(10)
                                .frame(maxWidth: isPad ? 300 : 150)
                                .background(Color.brightOrange)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        HStack(spacing: 20) {
                            Button(action: {
                                if itemCounts > 0 {
                                    itemCounts -= 1
                                    addRemoveData()
                                    onCountChanged(itemCounts)
                                    NotificationCenter.default.post(
                                        name: .updateValueNotification,
                                        object: nil,
                                        userInfo: ["value": -1]
                                    )
                                }
                                if itemCounts == 0 {
                                    isAddToCartButtonVisible = 0
                                }
                            }) {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                                    .font(.system(size: 30))
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Text("\(itemCounts)")
                                .font(.system(size: 20, weight: .semibold))
                                .frame(width: 40)
                            
                            Button(action: {
                                if let itemDesc = itemDesc,
                                   let availableCount = Int(itemDesc),
                                   itemCounts < availableCount {
                                    itemCounts += 1
                                    addRemoveData()
                                    onCountChanged(itemCounts)
                                    NotificationCenter.default.post(
                                        name: .updateValueNotification,
                                        object: nil,
                                        userInfo: ["value": +1]
                                    )
                                }
                                
                               
                            }) {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.brightOrange)
                                    .font(.system(size: 30))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.top, 5)
                    }
                }
            }
            VStack(alignment: .leading, spacing: 10) {
                Text(itemName)
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(.primary)
                Text(itemDetail)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                if let itemDesc = itemDesc {
                    Text("Available: \(itemDesc)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.red)
                }
                if !hideDeleteButton {
                    HStack {
                        Spacer()
                        Button(action: {
                            onDelete()
                        }) {
                            Image(systemName: "trash")
                                .font(.system(size: 20))
                                .foregroundColor(.red)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            if isCheckboxVisible {
                Button(action: {
                    onCheckUncheck()
                    isChecked.toggle()
                    print("Checkbox tapped: \(isChecked ? "Checked" : "Unchecked")")
                }) {
                    Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 30))
                        .foregroundColor(isChecked ? .brightOrange : .gray)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
    }
    
    func addRemoveData() {
        let parameters: [String: Any] = [
            "emp_code": UserDefaultsManager.shared.getEmpCode(),
            "ITEM_NAME" : itemMasterId ?? "",
            "items_in_cart": "\(itemCounts)",
            "to_date": "\(formattedDate(UserDefaultsManager.shared.getToDate() ?? Date()))",
            "from_date" : "\(formattedDate(UserDefaultsManager.shared.getFromDate() ?? Date()))"
        ]
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.addtocart,
            method: .post,
            param: parameters,
            model: AddRemoveData.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if let data = model.data {
                        print("Fetched items: \(data)")
                    } else {
                        print("No data received")
                    }
                case .failure(let error):
                    print("API Error: \(error)")
                }
            }
        }
    }
    func deleteCartItem() {
        let parameters: [String: Any] = [
            "emp_code": UserDefaultsManager.shared.getEmpCode(),
            "product_id" : "\(itemMasterId ?? "")"]
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.deleteCartItem,
            method: .post,
            param: parameters,
            model: RemoveData.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if let data = model.data {
                        ToastManager.shared.show(message: model.message ?? "Success")
                        print("Fetched items: \(data)")
                        //onDelete()
                    } else {
                        print("No data received")
                    }
                case .failure(let error):
                    print("API Error: \(error)")
                }
            }
        }
    }
}
