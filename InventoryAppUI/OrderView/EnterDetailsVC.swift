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
    @State private var vehicleGroups: [VehicleDetailGroup] = []
    @Binding var scannedItems: [String]
    @State private var pdfURL: URL? = nil
    @State private var isShowingWebView = false
    
    let order: ItemDetail
    let data = ["HSN/SAC Code","Team Member","Vehicle"]
    
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
                            multiSelectValues: $multiSelectValues,
                            vehicleGroups: $vehicleGroups
                        )
                    }
                    HStack {
                        Button(action: {
                            if let validationMessage = validateForm() {
                                ToastManager.shared.show(message: validationMessage)
                                return
                            }
                            let teamMemberIDs = multiSelectValues[1] ?? []
                            let hsnCode = textFieldValues[0]
                            
                            let vehicleDetails = vehicleGroups.map { group in
                                return [
                                    "vehicle": group.selectedVehicleID,
                                    "vehicleNo": group.vehicleNumber,
                                    "name": group.driverName,
                                    "contact": group.driverContact,
                                    "ewayBillAmount": group.awayBillAmount,
                                    "ewayBillNo": group.ewayBillNo,
                                    "ewayBillDate": group.ewayBillDate
                                ]
                            }
                            
                            addSaveChallanmaster(hsnCode: hsnCode,
                                                 teamMemberIDs: teamMemberIDs,
                                                 vehicleDetails: vehicleDetails,
                                                 itemQRStrings: scannedItems,
                                                 tempID: order.tempID)
                            defer {
                                submitChallanMaster(tempID: order.tempID)
                            }
                            
                        }){
                            Text("Submit")
                                .font(.headline)
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(Color.brightOrange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(5)
                    }
                }
                
            }
            .onAppear {
                getCrewMemberDetail()
                getTransportCategory()
            }
            .overlay(ToastView())
            .navigationTitle("Enter Details")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $isShowingWebView) {
                if let url = pdfURL {
                    ZStack {
                        WebView(url: url)
                            .edgesIgnoringSafeArea(.all)
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    isShowingWebView = false
                                    orderView()
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.black)
                                        .padding()
                                }
                            }
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    downloadPDF(from: url)
                                }) {
                                    HStack {
                                        Image(systemName: "arrow.down.circle.fill")
                                        Text("Download")
                                    }
                                    .padding()
                                    .background(Color.brightOrange)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.bottom, 20)
                                    .padding(.trailing, 20)
                                }
                            }
                        }
                    }
                }
            }
            
        }
    }
    func downloadPDF(from url: URL) {
        let task = URLSession.shared.downloadTask(with: url) { tempURL, response, error in
            if let tempURL = tempURL {
                do {
                    let fileManager = FileManager.default
                    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let destinationURL = documentsURL.appendingPathComponent(url.lastPathComponent)
                    
                    if fileManager.fileExists(atPath: destinationURL.path) {
                        try fileManager.removeItem(at: destinationURL)
                    }
                    try fileManager.copyItem(at: tempURL, to: destinationURL)
                    DispatchQueue.main.async {
                        ToastManager.shared.show(message: "PDF downloaded to Files app")
                    }
                } catch {
                    DispatchQueue.main.async {
                        ToastManager.shared.show(message: "Download failed: \(error.localizedDescription)")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    ToastManager.shared.show(message: "Download failed")
                }
            }
        }
        task.resume()
    }
    
    func validateForm() -> String? {
        if textFieldValues[0].isEmpty {
            return "Please enter HSN/SAC Code"
        }
        if (multiSelectValues[1]?.isEmpty ?? true) {
            return "Please select at least one Team Member"
        }
        if vehicleGroups.isEmpty {
            return "Please add at least one Vehicle"
        }
        
        for (index, group) in vehicleGroups.enumerated() {
            if group.selectedVehicleID.isEmpty {
                return "Please select a vehicle for entry \(index + 1)"
            }
            if group.vehicleNumber.isEmpty {
                return "Please enter vehicle number for entry \(index + 1)"
            }
            if group.driverName.isEmpty {
                return "Please enter driver name for entry \(index + 1)"
            }
            if group.driverContact.count != 10 && !group.driverContact.isEmpty {
                Text("Please enter a 10-digit mobile number.")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            if group.awayBillAmount.isEmpty {
                return "Please enter eWay Bill Amount for entry \(index + 1)"
            }
            if group.ewayBillNo.isEmpty {
                return "Please enter eWay Bill Number for entry \(index + 1)"
            }
            if group.ewayBillDate.isEmpty {
                return "Please select eWay Bill Date for entry \(index + 1)"
            }
        }
        
        return nil
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
    
    func addSaveChallanmaster(hsnCode: String,
                              teamMemberIDs: [String],
                              vehicleDetails: [[String: Any]],
                              itemQRStrings: [String],
                              tempID: String) {
        
        var dict = [String: Any]()
        dict["challan_status"] = "0"
        dict["temp_id"] = "\(tempID)"
        dict["emp_code"] = UserDefaultsManager.shared.getEmpCode()
        dict["hsn_sac_code"] = hsnCode
        dict["team_member"] = teamMemberIDs
        dict["transporter"] = vehicleDetails
        dict["item_qr_string"] = itemQRStrings

        ApiClient.shared.callmethodMultipart(apiendpoint: Constant.addSaveChallanmaster, method: .post, param: dict, model: SaveChallanMaster.self) { result in
            switch result {
            case .success(let model):
                if let data = model.data {
                    print("Fetched items: \(data)")
                    submitChallanMaster(tempID: data.temp_id ?? "\(tempID)")
                    ToastManager.shared.show(message: model.message ?? "Success")
                } else {
                    print("No data received")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func submitChallanMaster(tempID: String) {
        var dict = [String: Any]()
        dict["temp_id"] = "\(tempID)"
        dict["emp_code"] = UserDefaultsManager.shared.getEmpCode()
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.submitChallanMaster,
            method: .post,
            param: dict,
            model: SubmitChallan.self
        ) { result in
            switch result {
            case .success(let model):
                if let urlString = model.data,
                   let encodedURLString = (Constant.BASEURL + "Files/" + urlString).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                   let url = URL(string: encodedURLString) {
                    DispatchQueue.main.async {
                        print("PDF URL to load: \(url.absoluteString)")
                        self.pdfURL = url
                        self.isShowingWebView = true
                    }
                } else {
                    ToastManager.shared.show(message: "No valid URL received")
                }
            case .failure(let error):
                print(error)
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

struct TextFieldCell: View {
    let data: String
    @Binding var textFieldValue: String
    let index: Int
    @Binding var teamVehicle: [Transport]
    @Binding var teamMembers: [CrewMember]
    @Binding var multiSelectValues: [Int: [String]]
    @State private var showVehicleFields = false
    @Binding var vehicleGroups: [VehicleDetailGroup]
    
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
                                    TextField("Vehicle Number", text: $group.vehicleNumber)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .keyboardType(.asciiCapable)
                                        .autocapitalization(.allCharacters)
                                        .font(.footnote)
                                        .onChange(of: group.vehicleNumber) { newValue in
                                            let filtered = newValue.uppercased().filter { $0.isLetter || $0.isNumber }
                                                group.vehicleNumber = filtered
                                        }
                                    TextField("Select Vehicle", text: Binding(
                                        get: {
                                            teamVehicle.first(where: { $0.id == group.selectedVehicleID })?.transport_name ?? ""
                                        },
                                        set: { _ in }
                                    ))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .disabled(true)
                                    Menu {
                                        ForEach(teamVehicle, id: \.id) { vehicle in
                                            Button(action: {
                                                group.selectedVehicleID = vehicle.id ?? ""
                                            }) {
                                                Text(vehicle.transport_name ?? "Unknown")
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "chevron.down")
                                            .padding(8)
                                            .background(Color(UIColor.systemGray5))
                                            .cornerRadius(8)
                                    }
                                    
                                    
                                }
                                HStack {
                                    TextField("Driver Name", text: $group.driverName)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    
                                    TextField("Driver Contact", text: $group.driverContact)
                                        .keyboardType(.numberPad)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .onChange(of: group.driverContact) { newValue in
                                            let filtered = newValue.filter { $0.isNumber }
                                            if filtered.count > 10 {
                                                group.driverContact = String(filtered.prefix(10))
                                            } else {
                                                group.driverContact = filtered
                                            }
                                        }
                                }
                                HStack {
                                    TextField("Bill No", text: $group.ewayBillNo)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    TextField("Bill Amount", text: $group.awayBillAmount)
                                        .keyboardType(.numberPad)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    
                                }
//                                HStack {
//                                   
////                                    DatePicker(
////                                        "Bill Date",
////                                        selection: Binding<Date>(
////                                            get: {
////                                                let formatter = DateFormatter()
////                                                formatter.dateFormat = "yyyy-MM-dd"
////                                                return formatter.date(from: group.ewayBillDate) ?? Date()
////                                            },
////                                            set: { newValue in
////                                                let formatter = DateFormatter()
////                                                formatter.dateFormat = "yyyy-MM-dd"
////                                                group.ewayBillDate = formatter.string(from: newValue)
////                                            }
////                                        ),
////                                        displayedComponents: [.date]
////                                    )
////                                    .datePickerStyle(CompactDatePickerStyle())
//                                }
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
    var ewayBillDate: String = (formattedDate(Date())) 
    
}

