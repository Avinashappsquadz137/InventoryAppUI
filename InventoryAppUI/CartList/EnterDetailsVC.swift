//
//  EnterDetailsVC.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 17/12/24.
//

import SwiftUI

struct EnterDetailsVC: View {
    
    let order: ItemDetail
    @State private var textFieldValues: [String] = Array(repeating: "", count: 10)
    @State private var teamMembers: [String] = []
    @State private var multiSelectValues: [Int: [String]] = [:]
    @State private var tempID: String?
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State var showDateilScreen = false
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDate: Date = Date()
    
    let data = [
        "Consignee", "Transporter", "Consigner", "HSN/SAC Code",
        "Eway Bill Transaction", "Eway Bill No", "Eway Bill Date", "Team Member", "Transport Id","RENTAMOUNT"
    ]
    let userDefaultsKey = "TextFieldValues"
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(0..<data.count, id: \.self) { index in
                        TextFieldCell(
                            data: data[index],
                            textFieldValue: Binding(
                                get: { textFieldValues[index] },
                                set: { newValue in
                                    textFieldValues[index] = newValue
                                    saveTextFieldValues() // Save changes to UserDefaults
                                }
                            ),
                            index: index,
                            teamMembers: $teamMembers,
                            multiSelectValues: $multiSelectValues
                        )
                    }
                }
                
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Validation Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                HStack {
                    Button("Submit") {
                        validateTextFields { isValid, collectedData in
                            if isValid {
                                print("Form is valid: \(collectedData)")
                                addSaveChallanmaster()
                            } else {
                                alertMessage = "Please fill all required fields."
                                showAlert.toggle()
                            }
                        }
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Button("Clear") {
                        clearTextFields()
                    }
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .onAppear {
                loadTextFieldValues()
                getMemberDetail()
             
            }
            .modifier(ViewModifiers())
            .navigationTitle("Enter Details")
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
            }
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
    
    func getMemberDetail() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            teamMembers = ["John Doe", "Jane Smith", "Robert Brown"] // Simulated API response
        }
    }
    func clearTextFields() {
        textFieldValues = Array(repeating: "", count: data.count)
        saveTextFieldValues()
    }
    
    func addSaveChallanmaster() {
        var dict = [String: Any]()
        dict["challan_status"] = "0"
        dict["temp_id"] = "\(order.tempID)"
        dict["item_qr_string"] = ["1378_125_1722507307310","1409_125_1722507307380","1460_129_1722507307495","1461_129_1722507307498"]
        dict["emp_code"] = "SANS-00290"
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
                dict["team_member"] = [textFieldValues[index]]
            case "Transport Id":
                dict["transport_id"] = textFieldValues[index]
            case "RENTAMOUNT":
                dict["RENTAMOUNT"] = textFieldValues[index]
            default:
                break
            }
        }
        ApiClient.shared.callmethodMultipart(apiendpoint: Constant.addSaveChallanmaster, method: .post, param: dict, model: SaveChallanMaster.self){ result in
            switch result {
            case .success(let model):
                if let data = model.data {
                    print("Fetched items: \(data)")
                } else {
                    print("No data received")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct TextFieldCell: View {
    let data: String
    @Binding var textFieldValue: String
    let index: Int
    @Binding var teamMembers: [String]
    @Binding var multiSelectValues: [Int: [String]]
    
    var body: some View {
        VStack {
            Text(data)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            if data == "Team Member" {
                Picker("Select Team Member", selection: $textFieldValue) {
                    ForEach(teamMembers, id: \.self) { member in
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

