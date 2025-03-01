//
//  CreateChallanDetails.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 17/01/25.
//

import SwiftUI

struct CreateChallanDetails: View {
    
    @State private var textFieldValues: [String] = Array(repeating: "", count: 11)
    @State private var multiSelectValues: [Int: [String]] = [:]
    @State private var tempID: String?
    @State private var alertMessage: String = ""
    @State var showDateilScreen = false
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDate: Date = Date()
    @State private var isSubmitting = false
    let checkedStates: [String]
    
    let data = ["Client Name","Location","Company Name & Address","GST No", "State","Pincode","Contact Person","Mobile No","Show Start Date","Show End Date","Inventory Loading Date"]
    
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
                                }
                            ),
                            index: index,
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
                    .background(Color.brightOrange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(10)
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
    func validateTextFields(completion: (_ isValid: Bool, _ collectedData: [String]) -> Void) {
        let missingFields = textFieldValues.enumerated().compactMap { (index, value) -> String? in
            let fieldName = data[index]
            
            if fieldName == "Show Start Date" || fieldName == "Show End Date" {
                return nil
            }
            return value.isEmpty ? fieldName : nil
        }
        
        if missingFields.isEmpty {
            completion(true, textFieldValues)
        } else {
            print("The following fields are missing: \(missingFields.joined(separator: ", "))")
            completion(false, missingFields)
        }
    }
    func createOrderByCartItem() {
        guard !isSubmitting else { return }
            isSubmitting = true
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
                dict["showStartDate"] = "\(formattedDate(UserDefaultsManager.shared.getFromDate() ?? Date()))"
            case "Show End Date":
                dict["showEndDate"] = "\(formattedDate(UserDefaultsManager.shared.getToDate() ?? Date()))"
            case "Inventory Loading Date":
                dict["inventoryLoadingDate"] = textFieldValues[index]
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            isSubmitting = false
                            if let window = UIApplication.shared.windows.first {
                                window.rootViewController = UIHostingController(rootView: MAinTabbarVC().environment(\.colorScheme, .light))
                                window.makeKeyAndVisible()
                            }
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
    
}



struct DetailsFieldCell: View {
    let data: String
    @Binding var textFieldValue: String
    let index: Int
    @Binding var multiSelectValues: [Int: [String]]
    
    var body: some View {
        VStack {
            Text(data)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            if data == "Inventory Loading Date" {
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
                    in: Date()...,
                    displayedComponents: [.date]
                )
                .datePickerStyle(CompactDatePickerStyle())
            }else if data == "Show Start Date" {
                let defaultStartDate = UserDefaultsManager.shared.getFromDate() ?? Date()
                DatePicker(
                    "\(data)",
                    selection: Binding(
                        get: {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            return formatter.date(from: textFieldValue) ?? defaultStartDate
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
                .disabled(true)
                
            }else if data == "Show End Date" {
                let defaultEndDate = UserDefaultsManager.shared.getToDate() ?? Date()
                DatePicker(
                    "\(data)",
                    selection: Binding(
                        get: {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            return formatter.date(from: textFieldValue) ?? defaultEndDate
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
                .disabled(true)
            } else if data == "Mobile No" {
                TextField("Enter \(data)", text: $textFieldValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .onChange(of: textFieldValue) { newValue in
                        let filtered = newValue.filter { $0.isNumber }
                        if filtered.count > 10 {
                            textFieldValue = String(filtered.prefix(10))
                        } else {
                            textFieldValue = filtered
                        }
                    }
            } else if data == "GST No" {
                TextField("Enter \(data)", text: $textFieldValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: textFieldValue) { newValue in
                        let filtered = newValue.uppercased().filter { $0.isLetter || $0.isNumber }
                        if filtered.count > 15 {
                            textFieldValue = String(filtered.prefix(15))
                        } else {
                            textFieldValue = filtered
                        }
                    }
            }else if data == "Pincode" {
                TextField("Enter \(data)", text: $textFieldValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .onChange(of: textFieldValue) { newValue in
                        let filtered = newValue.filter { $0.isNumber }
                        if filtered.count > 6 {
                            textFieldValue = String(filtered.prefix(6))
                        } else {
                            textFieldValue = filtered
                        }
                    }
                
            }else {
                TextField("Enter \(data)", text: $textFieldValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
        .padding(1)
    }
}

