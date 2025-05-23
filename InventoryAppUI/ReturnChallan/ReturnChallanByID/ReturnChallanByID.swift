//
//  ReturnChallanByID.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 10/01/25.
//

import SwiftUI

struct ReturnChallanByID: View {
    
    @State private var challanDetail: ChallanIDModal? = nil
    @State private var textFieldValue: String = ""
    @State private var texteWayBill: String = ""
    @State private var textVehicleNo: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var isNavigatingToNext = false
    
    var body: some View {
        NavigationStack {
            ScrollView{
            VStack {
                Text("Enter Challan ID")
                    .font(.title)
                    .fontWeight(.bold)
                    .keyboardType(.numberPad)
                TextField("Enter Challan ID", text: $textFieldValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    print("Button tapped with text: \(textFieldValue)")
                    getItemDetailByChallanId()
                }) {
                    Text("Submit")
                        .font(.headline)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(Color.brightOrange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                if let challanDetail = challanDetail {
                    VStack(alignment: .leading , spacing: 12) {
                        Text("Client Name : \(challanDetail.client_name ?? "")")
                            .font(.headline)
                        Text("Location : \(challanDetail.location ?? "")")
                            .font(.headline)
                        Text("GST NO : \(challanDetail.gst_no ?? "")")
                            .font(.headline)
                        Text("State : \(challanDetail.state ?? "")")
                            .font(.headline)
                        Text("PinCode : \(challanDetail.pincode ?? "")")
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .onChange(of: textFieldValue) { newValue in
                                textFieldValue = String(newValue.prefix(6)).filter { $0.isNumber }
                            }
                        VStack(alignment: .leading, spacing: 0) {
                            Text("eWayBill")
                                .font(.headline)
                                .padding(.top, 0)
                            TextField("Enter eWayBill", text: $texteWayBill)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Vehicle No")
                                .font(.headline)
                                .padding(.top, 0)
                            TextField("Enter Vehicle No", text: $textVehicleNo)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    
                }
                Spacer()
                if challanDetail != nil {
                    NavigationLink(
                        destination: Group {
                            if let detail = challanDetail {
                                ReturnChallanItemView(
                                    challanDetail: detail,
                                    isCheckboxVisible: true,
                                    texteWayBill: texteWayBill,
                                    textVehicleNo: textVehicleNo
                                )
                            }
                        },
                        isActive: $isNavigatingToNext,
                        label: {
                            Text("Next")
                                .font(.headline)
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(texteWayBill.isEmpty || textVehicleNo.isEmpty ? Color.brightOrange.opacity(0.3) : Color.brightOrange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    )
                    .disabled(texteWayBill.isEmpty || textVehicleNo.isEmpty)
                }
            }
        }
            .padding()
            .modifier(ViewModifiers())
            .navigationTitle("Enter Challan ID")
            .navigationBarTitleDisplayMode(.inline)
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
            }.overlay(ToastView())
        }
    }
    func getItemDetailByChallanId() {
        let parameters: [String: Any] = ["emp_code": UserDefaultsManager.shared.getEmpCode(),"type": "1","challan_id":"\(textFieldValue)"]
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getItemDetailByChallanId,
            method: .post,
            param: parameters,
            model: EnterChallanIDModal.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if let data = model.data {
                        self.challanDetail = data
                        ToastManager.shared.show(message: model.message ?? "Added Successfully")
                        print("Fetched items: \(data)")
                    } else {
                        print("No data received")
                    }
                case .failure(let error):
                    self.challanDetail = nil
                    ToastManager.shared.show(message: "Enter Correct ID")
                    print("API Error: \(error)")
                }
            }
        }
    }
}

struct ReturnChallanByID_Previews: PreviewProvider {
    static var previews: some View {
        ReturnChallanByID()
            .previewDevice("iPhone 14")
            .preferredColorScheme(.light)
    }
}
