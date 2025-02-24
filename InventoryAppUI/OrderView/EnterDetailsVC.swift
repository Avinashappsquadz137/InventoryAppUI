//
//  EnterDetailsVC.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 17/12/24.
//

import SwiftUI

struct EnterDetailsVC: View {
    
    @State private var navigateToScannedItemsView = false
    @State private var textFieldValues: [String] = Array(repeating: "", count: 11)
    @State private var teamMembers: [CrewMember] = []
    @State private var teamVehicle: [Transport] = []
    @State private var multiSelectValues: [Int: [String]] = [:]
    @State private var tempID: String?
    @State private var alertMessage: String = ""
    @State var showDateilScreen = false
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDate: Date = Date()
    
    let order: ItemDetail
    let data = [
        "Consignee", "Transporter", "Consigner", "HSN/SAC Code",
        "Eway Bill Transaction", "Eway Bill No", "Eway Bill Date", "Team Member", "Transport Id","Vehicle","Vehicle No"
    ]
 
    
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
                                }
                            ),
                            index: index,
                            teamVehicle: $teamVehicle, teamMembers: $teamMembers,
                            multiSelectValues: $multiSelectValues
                        )
                    }
                }
                HStack {
                    Button("SAVE") {
                        validateTextFields { isValid, collectedData in
                            if isValid {
                                print("Form is valid: \(collectedData)")
                                navigateToScannedItemsView = true
                            } else {
                                ToastManager.shared.show(message:"Please fill all required fields.")
                            }
                        }
                    }
                    .padding()
                    .background(Color.brightOrange)
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
                getCrewMemberDetail()
                getTransportCategory()
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
            }.overlay(ToastView())
            NavigationLink(
                destination: ShowScannedItemsView(order: order,textFieldValues: $textFieldValues, multiSelectValues: $multiSelectValues, teamMembers: teamMembers, data: data),
                isActive: $navigateToScannedItemsView,
                label: { EmptyView() }
            )
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

    func clearTextFields() {
        textFieldValues = Array(repeating: "", count: data.count)
    }
        func getTransportCategory() {
            var dict = [String: Any]()
            dict["emp_code"] = "1"
            ApiClient.shared.callmethodMultipart(apiendpoint: Constant.getTransportCategory, method: .post, param: dict, model: TransportCategory.self){ result in
                switch result {
                case .success(let model):
                    if let data = model.data {
                        self.teamVehicle = data
                        print("Fetched items: \(data)")
                    } else {
                        print("No data received")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    func getCrewMemberDetail() {
        ApiClient.shared.callmethodMultipart(apiendpoint: Constant.getCrewMember, method: .post, param: [:], model: CrewMemberModel.self){ result in
            switch result {
            case .success(let model):
                self.teamMembers = model.data ?? []
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
    @Binding var teamVehicle: [Transport]
    @Binding var teamMembers: [CrewMember]
    @Binding var multiSelectValues: [Int: [String]]
    
    var body: some View {
        VStack {
            Text(data)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            if data == "Vehicle" {
                Picker("Select Vehicle", selection: $textFieldValue) {
                    ForEach(teamVehicle, id: \.id) { vehicle in
                        Text(vehicle.transport_name ?? "Unknown").tag(vehicle.id ?? "")
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: textFieldValue) { newValue in
                    
                }
            } else if data == "Team Member" {
                NavigationLink(
                    destination: MultiSelectView(
                        teamMembers: teamMembers,
                        selectedMembers: Binding(
                            get: { multiSelectValues[index] ?? [] },
                            set: { newSelection in
                                multiSelectValues[index] = newSelection
                                textFieldValue = newSelection.joined(separator: ", ")
                            }
                        ),
                        selectedNames: Binding(
                            get: { multiSelectValues[index + 100] ?? [] }, // Store names separately
                            set: { newNames in
                                multiSelectValues[index + 100] = newNames
                                textFieldValue = newNames.joined(separator: ", ") // Update text field with names
                            }
                        )
                    )
                ) {
                    HStack {
                        Text(textFieldValue.isEmpty ? "Select Team Members" : textFieldValue)
                            .foregroundColor(textFieldValue.isEmpty ? .gray : .primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
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

struct MultiSelectView: View {
    let teamMembers: [CrewMember]
    @Binding var selectedMembers: [String]
    @Binding var selectedNames: [String]

    var body: some View {
        List {
            ForEach(teamMembers, id: \.id) { member in
                HStack {
                    Text(member.emp_name ?? "Unknown")
                    Spacer()
                    if selectedMembers.contains(member.id ?? "") {
                        Image(systemName: "checkmark")
                            .foregroundColor(.brightOrange)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if let memberId = member.id, let memberName = member.emp_name {
                        if let index = selectedMembers.firstIndex(of: memberId) {
                            selectedMembers.remove(at: index)
                            selectedNames.remove(at: index)
                        } else {
                            selectedMembers.append(memberId)
                            selectedNames.append(memberName)
                        }
                    }
                }
            }
        }
        .navigationTitle("Select Team Members")
    }
}
