//
//  CreateChallanDetails.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 17/01/25.
//

import SwiftUI

struct CreateChallanDetails: View {
    

    @State private var textFieldValues: [String] = Array(repeating: "", count: 13)
    @State private var teamVehicle: [String] = []
    @State private var multiSelectValues: [Int: [String]] = [:]
    @State private var tempID: String?
    @State private var alertMessage: String = ""
    @State var showDateilScreen = false
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDate: Date = Date()
    let checkedStates: [String]
 
//    let arrar = ["emp_code","items_in_cart","client_name","location","company_name_and_address","gst_no","state","pincode","contactPerson","mobileNo","showStartDate","showEndDate","inventoryLoadingDate","vehicle","vehicleNo"]
    let data = ["Client Name","Location","Company Name & Address","GST No", "State","Pincode","Contact Person","Mobile No","Show Start Date","Show End Date","Inventory Loading Date","Vehicle","Vehicle No"]

    let userDefaultsKey = "TextFieldValues"
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(0..<data.count, id: \.self) { index in
                        DetailsFieldCell(
                            data: data[index],
                            textFieldValue: Binding(
                                get: { textFieldValues[index] },
                                set: { newValue in
                                    textFieldValues[index] = newValue
                                    saveTextFieldValues()
                                }
                            ),
                            index: index,
                            teamVehicle: $teamVehicle,
                            multiSelectValues: $multiSelectValues
                        )
                    }
                }
                HStack {
                    Button("Submit") {
                        validateTextFields { isValid, collectedData in
                            if isValid {
                                print("Form is valid: \(collectedData)")
                                createOrderByCartItem()
                            } else {
                                ToastManager.shared.show(message:"Please fill all required fields.")
                            }
                        }
                    }
                    .font(.headline)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(10)
            }
            .onAppear {
                loadTextFieldValues()
                getTransportCategory()
            }
            .modifier(ViewModifiers())
            .navigationTitle("Enter Challan Details")
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
    func saveTextFieldValues() {
        UserDefaults.standard.set(textFieldValues, forKey: userDefaultsKey)
    }
    func loadTextFieldValues() {
        if let savedValues = UserDefaults.standard.array(forKey: userDefaultsKey) as? [String], savedValues.count == data.count {
            textFieldValues = savedValues
        }
    }
    func validateTextFields(completion: (_ isValid: Bool, _ collectedData: [String]) -> Void) {
        let allFieldsFilled = !textFieldValues.contains(where: { $0.isEmpty })
        if allFieldsFilled {
            completion(true, textFieldValues)
        } else {
            completion(false, [])
        }
    }
    func getTransportCategory() {
        var dict = [String: Any]()
        dict["emp_code"] = "1"
        ApiClient.shared.callmethodMultipart(apiendpoint: Constant.getTransportCategory, method: .post, param: dict, model: TransportCategory.self){ result in
            switch result {
            case .success(let model):
                if let data = model.data {
                    self.teamVehicle = model.data?.compactMap { $0.transport_name } ?? []
                    print("Fetched items: \(data)")
                } else {
                    print("No data received")
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func createOrderByCartItem() {
        var dict = [String: Any]()
        dict["emp_code"] = "1"
        dict["items_in_cart"] = checkedStates
        for (index, field) in data.enumerated() {
            switch field {
            case "Client Name":
                dict["client_name"] = textFieldValues[index]
            case "Location":
                dict["location"] = textFieldValues[index]
            case "Company Name & Address":
                dict["company_name_and_address"] = textFieldValues[index]
            case "GST No":
                dict["gst_no"] = textFieldValues[index]
            case "State":
                dict["state"] = textFieldValues[index]
            case "Pincode":
                dict["pincode"] = textFieldValues[index]
            case "Contact Person":
                dict["contactPerson"] = textFieldValues[index]
            case "Mobile No":
                dict["mobileNo"] = textFieldValues[index]
            case "Show Start Date":
                dict["showStartDate"] = textFieldValues[index]
            case "Show End Date":
                dict["showEndDate"] = textFieldValues[index]
            case "Inventory Loading Date":
                dict["inventoryLoadingDate"] = textFieldValues[index]
            case "Vehicle":
                dict["vehicle"] = textFieldValues[index]
            case "Vehicle No":
                dict["vehicleNo"] = textFieldValues[index]
            default:
                break
            }
        }
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.createOrderByCartItem,
            method: .post,
            param: dict,
            model: GetAllCartList.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if let data = model.data {
                        print("Fetched items: \(data)")
                        ToastManager.shared.show(message: model.message ?? "")
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



struct DetailsFieldCell: View {
    let data: String
    @Binding var textFieldValue: String
    let index: Int
    @Binding var teamVehicle: [String]
    @Binding var multiSelectValues: [Int: [String]]
    
    var body: some View {
        VStack {
            Text(data)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            if data == "Vehicle" {
                Picker("Select Vehicle", selection: $textFieldValue) {
                    ForEach(teamVehicle, id: \.self) { member in
                        Text(member).tag(member)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            } else if data == "Eway Bill Date" {
                DatePicker(
                    "Select \(data)",
                    selection: Binding(
                        get: {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            return formatter.date(from: textFieldValue) ?? Date()
                        },
                        set: { newValue in
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            textFieldValue = formatter.string(from: newValue)
                        }
                    ),
                    displayedComponents: [.date]
                )
                .datePickerStyle(CompactDatePickerStyle())
            }else {
                TextField("Enter \(data)", text: $textFieldValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
        .padding(1)
    }
}

