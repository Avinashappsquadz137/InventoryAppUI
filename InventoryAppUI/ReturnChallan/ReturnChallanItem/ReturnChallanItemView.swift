//
//  ReturnChallanItemView.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 15/01/25.
//

import SwiftUI

struct ReturnChallanItemView: View {
    
    var challanDetail: ChallanIDModal
    var texteWayBill: String
    var textVehicleNo: String
    @State private var isChecked = false
    @State private var itemCheckedStates: [Bool]
    
    init(challanDetail: ChallanIDModal, isCheckboxVisible: Bool, texteWayBill: String, textVehicleNo: String) {
        self.challanDetail = challanDetail
        self.texteWayBill = texteWayBill
        self.textVehicleNo = textVehicleNo
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
                        .foregroundColor(isChecked ? .brightOrange : .gray)
                }
                .padding(5)
            }
            .buttonStyle(PlainButtonStyle())
            
            if let products = challanDetail.products, !products.isEmpty {
                List(products.indices, id: \.self) { index in
                    ReturnChallanItemCell(
                        itemImageURL: "\(Constant.BASEURL)/\(products[index].iTEM_THUMBNAIL ?? "")",
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
                returnItemByChallanId()
            }) {
                Text("Submit Return")
                    .font(.headline)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.brightOrange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
        }
        .padding(10)
        .overlay(ToastView())
    }
    private func updateAllSelectState() {
        isChecked = itemCheckedStates.allSatisfy { $0 }
    }
    
    func returnItemByChallanId() {
        let selectedProducts = challanDetail.products?.enumerated()
            .filter { index, _ in itemCheckedStates[index] }
            .map { $0.element }
        let selectedProductIDs = selectedProducts?.compactMap { $0.iTEM_MASTER_ID } ?? []
        let parameters: [String: Any] = [
            "emp_code": UserDefaultsManager.shared.getEmpCode(),
            "challan_id": "\(challanDetail.temp_id ?? "")",
            "products" : selectedProductIDs,
            "vehicleNo" : textVehicleNo,
            "eway_bill_no" : texteWayBill]
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.returnItemByChallanId,
            method: .post,
            param: parameters,
            model: GetSuccessMessage.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if let data = model.data {
                        ToastManager.shared.show(message: model.message ?? "Success")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            orderView()
                        }
                    } else {
                        print("No data received")
                    }
                case .failure(let error):
                    print("API Error: \(error)")
                }
            }
        }
    }
    func orderView() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.rootViewController = UIHostingController(rootView: MAinTabbarVC().environment(\.colorScheme, .light))
            window.makeKeyAndVisible()
        }
    }
}
