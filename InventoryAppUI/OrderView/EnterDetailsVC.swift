//
//  EnterDetailsVC.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 17/12/24.
//

import SwiftUI

struct EnterDetailsVC: View {
    
   
    @State private var textFieldValues: [String] = Array(repeating: "", count: 3)
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
        "HSN/SAC Code","Team Member","Vehicle",
    ]
 
    //Consignee", "Transporter", "Consigner", "Transport Id, "Vehicle No""
    //"Eway Bill Amount", "Eway Bill No", "Eway Bill Date",
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
                    Button(action: {
                        validateTextFields { isValid, collectedData in
                            if isValid {
                                print("Form is valid: \(collectedData)")
                           
                            } else {
                                ToastManager.shared.show(message:"Please fill all required fields.")
                            }
                        }
                    }) {
                        Text("Submit")
                            .font(.headline)
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(Color.brightOrange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
            .onAppear {
                getCrewMemberDetail()
                getTransportCategory()
            }
            .modifier(ViewModifiers())
            .navigationTitle("Enter Details")
            .navigationBarTitleDisplayMode(.inline)
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
            dict["emp_code"] = UserDefaultsManager.shared.getEmpCode()
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
    @State private var showVehicleFields = false
    @State private var vehicleGroups: [VehicleDetailGroup] = [VehicleDetailGroup()]
    
    var body: some View {
        VStack {
            Text(data)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            if data == "Vehicle" {
                VStack(alignment: .leading, spacing: 8) {
                    if showVehicleFields {
                        ForEach($vehicleGroups) { $group in
                            Group {
                                HStack {
                                    Picker("Select Vehicle", selection: $group.selectedVehicleID) {
                                        ForEach(teamVehicle, id: \.id) { vehicle in
                                            Text(vehicle.transport_name ?? "Unknown")
                                                .tag(vehicle.id ?? "")
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                }
                                HStack {
                                    TextField("Vehicle Number", text: $group.vehicleNumber)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    TextField("Driver Contact", text: $group.driverContact)
                                        .keyboardType(.numberPad)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                }
                                HStack {
                                    TextField("Driver Name", text: $group.driverName)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    TextField("Bill Amount", text: $group.awayBillAmount)
                                        .keyboardType(.numberPad)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    
                                }
                                HStack {
                                    TextField("Bill No", text: $group.ewayBillNo)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    DatePicker(
                                        "Bill Date",
                                        selection: Binding<Date>(
                                            get: {
                                                let formatter = DateFormatter()
                                                formatter.dateFormat = "yyyy-MM-dd"
                                                return formatter.date(from: group.ewayBillDate) ?? Date()
                                            },
                                            set: { newValue in
                                                let formatter = DateFormatter()
                                                formatter.dateFormat = "yyyy-MM-dd"
                                                group.ewayBillDate = formatter.string(from: newValue)
                                            }
                                        ),
                                        displayedComponents: [.date]
                                    )
                                    .datePickerStyle(CompactDatePickerStyle())
                                }
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        if let index = vehicleGroups.firstIndex(where: { $0.id == group.id }) {
                                            vehicleGroups.remove(at: index)
                                        }
                                    }) {
                                        HStack {
                                            Image(systemName: "minus.circle")
                                            Text("Remove")
                                        }
                                        .foregroundColor(.red)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.bottom, 10)
                        }
                    }
                        Button(action: {
                            vehicleGroups.append(VehicleDetailGroup())
                            showVehicleFields = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add")
                            }
                            .padding(.top, 4)
                            .foregroundColor(.blue)
                        }
                        .buttonStyle(PlainButtonStyle())
                    
                }
            }  else if data == "Team Member" {
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
                            get: { multiSelectValues[index + 100] ?? [] },
                            set: { newNames in
                                multiSelectValues[index + 100] = newNames
                                textFieldValue = newNames.joined(separator: ", ")
                            }
                        )
                    )
                ) {
                    HStack {
                        Text(textFieldValue.isEmpty ? "Select Team Members" : textFieldValue)
                            .foregroundColor(textFieldValue.isEmpty ? .gray : .primary)
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
struct VehicleDetailGroup: Identifiable {
    let id = UUID()
    var selectedVehicleID: String = ""
    var vehicleNumber: String = ""
    var driverName: String = ""
    var driverContact: String = ""
    var awayBillAmount: String = ""
    var ewayBillNo: String = ""
    var ewayBillDate: String = ""
    
}

