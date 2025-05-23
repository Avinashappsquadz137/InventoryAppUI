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
    @State private var states: [StateItem] = []
    @State private var selectedStateID: String?

    
    let data = ["Event Name" ,"Client Name","Location","Company Name & Address","GST No", "State","Pincode","Mobile No","Start Date","End Date","Inventory Loading Date"]
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(0..<data.count, id: \.self) { index in
                        if data[index] == "Start Date" {
                            HStack {
                                // Show Start Date
                                DetailsFieldCell(
                                    data: "Start Date",
                                    textFieldValue: Binding(
                                        get: { textFieldValues[index] },
                                        set: { newValue in
                                            textFieldValues[index] = newValue
                                        }
                                    ),
                                    index: index,
                                    multiSelectValues: $multiSelectValues,
                                    showTitle: false, selectedStateID: $selectedStateID
                                )
                                
                                // Show End Date
                                if let endDateIndex = data.firstIndex(of: "End Date") {
                                    DetailsFieldCell(
                                        data: "End Date",
                                        textFieldValue: Binding(
                                            get: { textFieldValues[endDateIndex] },
                                            set: { newValue in
                                                textFieldValues[endDateIndex] = newValue
                                            }
                                        ),
                                        index: endDateIndex,
                                        multiSelectValues: $multiSelectValues,
                                        showTitle: false ,selectedStateID: $selectedStateID
                                    )
                                }
                            }
                        } else if data[index] != "End Date" {
                            // Normal fields (excluding "Show End Date" since it's shown above)
                            DetailsFieldCell(
                                data: data[index],
                                textFieldValue: Binding(
                                    get: { textFieldValues[index] },
                                    set: { newValue in
                                        textFieldValues[index] = newValue
                                    }
                                ),
                                index: index,
                                multiSelectValues: $multiSelectValues,
                                states: states ,selectedStateID: $selectedStateID
                            )
                        }
                    }
                }

                HStack {
                    Button("Submit") {
                        if let validationMessage = validateForm() {
                               ToastManager.shared.show(message: validationMessage)
                               return
                           }
                        createOrderByCartItem()
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
            .onAppear {
                getState()
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

    func validateForm() -> String? {
        for (index, value) in textFieldValues.enumerated() {
            let field = data[index]
            if field == "Start Date" || field == "End Date"  || field  == "Inventory Loading Date" {
                continue
            }
            
            if value.trimmingCharacters(in: .whitespaces).isEmpty {
                return "Please enter \(field)."
            }
            
            if field == "Mobile No" && value.count != 10 {
                return "Mobile number must be exactly 10 digits."
            }
            
            if field == "Pincode" && value.count != 6 {
                return "Pincode must be exactly 6 digits."
            }
            
            if field == "GST No" && value.count != 15 {
                return "GST No must be exactly 15 characters."
            }
        }
        return nil 
    }

    func createOrderByCartItem() {
        guard !isSubmitting else { return }
            isSubmitting = true
        var dict = [String: Any]()
        dict["emp_code"] = UserDefaultsManager.shared.getEmpCode()
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
                dict["state"] = selectedStateID ?? textFieldValues[index]
            case "Pincode":
                dict["pincode"] = textFieldValues[index]
            case "Event Name":
                dict["contactPerson"] = textFieldValues[index]
            case "Mobile No":
                dict["mobileNo"] = textFieldValues[index]
            case "Start Date":
                dict["showStartDate"] = "\(formattedDate(UserDefaultsManager.shared.getFromDate() ?? Date()))"
            case "End Date":
                dict["showEndDate"] = "\(formattedDate(UserDefaultsManager.shared.getToDate() ?? Date()))"
            case "Inventory Loading Date":
                let dateString = textFieldValues[index].isEmpty
                    ? inventoryDateFormatter.string(from: Date())
                    : textFieldValues[index]

                dict["inventoryLoadingDate"] = dateString
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
                        isSubmitting = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
    func getState() {
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getState,
            method: .post,
            param: [:],
            model: StateResponse.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.states = response.data
                    ToastManager.shared.show(message: response.message ?? "States fetched successfully")
                case .failure(let error):
                    ToastManager.shared.show(message: error.localizedDescription)
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
    var states: [StateItem] = []
    var showTitle: Bool = true
    @Binding var selectedStateID: String?
    var body: some View {
        VStack {
            if showTitle {
                Text(data)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            if data == "Inventory Loading Date" {
                let defaultDate = inventoryDateFormatter.date(from: textFieldValue) ?? Date()
                DatePicker(
                    "Select \(data)",
                    selection: Binding(
                        get: {
                            inventoryDateFormatter.date(from: textFieldValue) ?? Date()
                        },
                        set: { newValue in
                            textFieldValue = inventoryDateFormatter.string(from: newValue)
                        }
                    ),
                    displayedComponents: [.date]
                )
                .datePickerStyle(CompactDatePickerStyle())
            }else if data == "Start Date" {
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
                
            }else if data == "End Date" {
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
                    .keyboardType(.asciiCapable)
                    .autocapitalization(.allCharacters)
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
                
            } else if data == "State" {
                VStack(alignment: .leading) {
                    HStack {
                        TextField("Choose a state", text: $textFieldValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disabled(true)
                        Menu {
                            ForEach(states, id: \.id) { state in
                                Button(action: {
                                    textFieldValue = state.name
                                    selectedStateID = state.id
                                }) {
                                    Text(state.name)
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.down")
                                .padding(8)
                                .background(Color(UIColor.systemGray5))
                                .cornerRadius(8)
                        }
                    }
                }
            } else {
                TextField("Enter \(data)", text: $textFieldValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
        .padding(1)
    }
}

struct StateResponse: Codable {
    let status: Bool
    let message: String?
    let data: [StateItem]
}

struct StateItem: Codable, Identifiable {
    let id: String
    let name: String
}
