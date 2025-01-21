//
//  EnterDetailsVC.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 17/12/24.
//

import SwiftUI

struct EnterDetailsVC: View {
    
    
    @State private var navigateToScannedItemsView = false
    @State private var textFieldValues: [String] = Array(repeating: "", count: 9)
    @State private var teamMembers: [String] = []
    @State private var multiSelectValues: [Int: [String]] = [:]
    @State private var tempID: String?
    @State private var alertMessage: String = ""
    @State var showDateilScreen = false
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDate: Date = Date()
    
    let order: ItemDetail
    let data = [
        "Consignee", "Transporter", "Consigner", "HSN/SAC Code",
        "Eway Bill Transaction", "Eway Bill No", "Eway Bill Date", "Team Member", "Transport Id"
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
                    .background(Color.blue)
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
                getCrewMemberDetail()
                
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
                destination: ShowScannedItemsView(order: order,textFieldValues: $textFieldValues, teamMembers: teamMembers, data: data),
                isActive: $navigateToScannedItemsView,
                label: { EmptyView() }
            )
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

    func clearTextFields() {
        textFieldValues = Array(repeating: "", count: data.count)
        saveTextFieldValues()
    }
    
    func getCrewMemberDetail() {
        ApiClient.shared.callmethodMultipart(apiendpoint: Constant.getCrewMember, method: .post, param: [:], model: CrewMemberModel.self){ result in
            switch result {
            case .success(let model):
                self.teamMembers = model.data?.compactMap { $0.emp_name } ?? []
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
                NavigationLink(
                    destination: MultiSelectView(
                        teamMembers: teamMembers,
                        selectedMembers: Binding(
                            get: { multiSelectValues[index] ?? [] },
                            set: { newSelection in
                                multiSelectValues[index] = newSelection
                                textFieldValue = newSelection.joined(separator: ", ")
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
    let teamMembers: [String]
    @Binding var selectedMembers: [String]
    
    var body: some View {
        List {
            ForEach(teamMembers, id: \.self) { member in
                HStack {
                    Text(member)
                    Spacer()
                    if selectedMembers.contains(member) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if selectedMembers.contains(member) {
                        selectedMembers.removeAll { $0 == member }
                    } else {
                        selectedMembers.append(member)
                    }
                }
            }
        }
        .navigationTitle("Select Team Members")
    }
}
