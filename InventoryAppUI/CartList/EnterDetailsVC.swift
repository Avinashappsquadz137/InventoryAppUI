//
//  EnterDetailsVC.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 17/12/24.
//

import SwiftUI

struct EnterDetailsVC: View {
    
    @State private var textFieldValues: [String] = Array(repeating: "", count: 9)
    @State private var teamMembers: [String] = []
    @State private var multiSelectValues: [Int: [String]] = [:]
    @State private var tempID: String?
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State var showDateilScreen = false
    
    let data = [
        "Consignee", "Transporter", "Consigner", "HSN/SAC Code",
        "Eway Bill Transaction", "Eway Bill No", "Eway Bill Date", "Team Member", "Transport Id"
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(0..<data.count, id: \.self) { index in
                        TextFieldCell(data: data[index], textFieldValue: $textFieldValues[index], index: index, teamMembers: $teamMembers, multiSelectValues: $multiSelectValues)
                    }.padding(10)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Validation Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                HStack {
                    Button("Submit") {
                        validateTextFields { isValid, collectedData in
                            if isValid {
                                // Call API or handle the submit
                                print("Form is valid: \(collectedData)")
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
                    
                    Button("Cancel") {
                        // Handle cancel action
                    }
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .onAppear {
                getMemberDetail()
                setNavigationBarAppearance() // Set white background for the navigation bar
            }
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
    
    func getMemberDetail() {
        // Simulate getting data
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            teamMembers = ["John Doe", "Jane Smith", "Robert Brown"] // Simulated API response
        }
    }
    
    // Custom function to set navigation bar appearance
    func setNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white // Set the background color to white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black] // Optional: set title color
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black] // Optional: set large title color
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
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
            } else {
                TextField("Enter \(data)", text: $textFieldValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
        .padding(1)
    }
}

struct RequestDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EnterDetailsVC()
    }
}