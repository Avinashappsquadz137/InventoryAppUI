//
//  AddProductRepairDetail.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 28/01/25.
//


import SwiftUI

struct AddProductRepairDetail: View {
    
    let product: RepairList?
    
    @State private var repairAddress: String = ""
    @State private var mobileNumber: String = ""
    @State private var repairCenterPhone: String = ""
    @State private var price: String = ""
    @State private var remarks: String = ""
    @State private var issueDate: Date = Date()
    @State private var repairingDate: Date = Date()
    @State private var selectedImageDamage: UIImage?
    @State private var selectedImageReceiptBill : UIImage?
    @State private var isImagePickerPresented: Bool = false
    @State private var isPickingForDamage: Bool = true
    @State private var isCamera: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Group {
                        Text("\(product?.iTEM_NAME ?? "Unknown")")
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(.primary)
                        SectionHeader("Repair Address")
                        TextField("Enter Repair Address", text: $repairAddress)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        SectionHeader("Mobile Number")
                        TextField("Enter Mobile Number", text: $mobileNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        
                        SectionHeader("Repair Center Phone")
                        TextField("Enter Repair Center Phone", text: $repairCenterPhone)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                    
                    Group {
                        SectionHeader("Repair Price")
                        TextField("Enter Price", text: $price)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                        
                        SectionHeader("Repair Issue Date")
                        DatePicker("Select Issue Date", selection: $issueDate, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                        
                        SectionHeader("Repairing Date")
                        DatePicker("Select Repairing Date", selection: $repairingDate, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                        
                        SectionHeader("Remarks")
                        TextField("Enter Remarks", text: $remarks)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    Group {
                        ImageUploadSection(
                            title: "Receipt Bill",
                            selectedImage: $selectedImageReceiptBill,
                            isImagePickerPresented: $isImagePickerPresented,
                            isPickingForDamage: $isPickingForDamage,
                            isCamera: $isCamera,
                            isDamage: false
                        )
                        ImageUploadSection(
                            title: "Damage Item Photo",
                            selectedImage: $selectedImageDamage,
                            isImagePickerPresented: $isImagePickerPresented,
                            isPickingForDamage: $isPickingForDamage,
                            isCamera: $isCamera,
                            isDamage: true
                        )
                    }
                    
                    Button(action: submitRepairDetails) {
                        Text("Add Product Repair Detail")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            .navigationTitle("Add Repair Details")
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(
                    image: isPickingForDamage ? $selectedImageDamage : $selectedImageReceiptBill,
                    isCamera: isCamera
                )
            }
        }
    }
    
    func submitRepairDetails() {
        // Implement submission logic here
        print("Submitting Repair Details")
    }
}

struct SectionHeader: View {
    var title: String
    init(_ title: String) {
        self.title = title
    }
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.primary)
    }
}

struct ImageUploadSection: View {
    let title: String
    @Binding var selectedImage: UIImage?
    @Binding var isImagePickerPresented: Bool
    @Binding var isPickingForDamage: Bool
    @Binding var isCamera: Bool
    var isDamage: Bool
    
    var body: some View {
        Group {
            SectionHeader(title)
            if let image = selectedImage {
                VStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(8)
                    
                    Button("Remove Image") {
                        selectedImage = nil
                    }
                    .font(.headline)
                    .foregroundColor(.red)
                }
            } else {
                Button(action: {
                    showImagePickerOptions()
                }) {
                    HStack {
                        Image(systemName: "photo")
                        Text("Upload Image")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .foregroundColor(.blue)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
                }
            }
        }
    }
    
    private func showImagePickerOptions() {
        isPickingForDamage = isDamage
        let actionSheet = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            isCamera = true
            isImagePickerPresented = true
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            isCamera = false
            isImagePickerPresented = true
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(actionSheet, animated: true)
        }
    }
}

