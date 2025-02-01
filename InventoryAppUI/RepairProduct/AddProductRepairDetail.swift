//
//  AddProductRepairDetail.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 28/01/25.
//


import SwiftUI
import UIKit

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
    
    @State private var itemRepair: [ItemRepairById] = []

    init(product: RepairList?) {
        self.product = product
        getItemRepairById()
    }
    
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
    
    func getItemRepairById() {
        var dict = [String: Any]()
        dict["emp_code"] = "1"
        dict["repair_id"] = product?.iTEM_REPAIR_ID
        
        ApiClient.shared.callmethodMultipart(apiendpoint: Constant.getItemRepairById, method: .post, param: dict, model: GetItemRepairByIdModel.self){ result in
            switch result {
            case .success(let model):
                if let data = model.data {
                    DispatchQueue.main.async {
                        self.itemRepair = [data]
                    }
                    print("Fetched items: \(data)")
                } else {
                    print("No data received")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func submitRepairDetails() {
        var dict = [String: Any]()
        dict["emp_code"] = "1"
        dict["product_id"] = product?.iTEM_MASTER_ID ?? "" 
        dict["repair_address"] = repairAddress
        dict["phone_no"] = mobileNumber
        dict["repair_price"] = price
        dict["issue_date"] = formattedDate(issueDate)
        dict["repair_date"] = formattedDate(repairingDate)
        dict["remarks"] = remarks
        dict["repair_id"] = product?.iTEM_REPAIR_ID
        
        var images: [String: Data] = [:]
        
        if let damageImageData = selectedImageDamage?.jpegData(compressionQuality: 0.7) {
            print("Damage image data size: \(damageImageData.count) bytes")
            images["thumbnail"] = damageImageData
        } else {
            print("Failed to convert damage image to data")
        }

        if let receiptImageData = selectedImageReceiptBill?.jpegData(compressionQuality: 0.7) {
            print("Receipt image data size: \(receiptImageData.count) bytes")
            images["receipt_bill"] = receiptImageData
        } else {
            print("Failed to convert receipt image to data")
        }
        print(dict)
        ApiClient.shared.callHttpMethod(apiendpoint: Constant.updateItemRepairDetail, method: .post, param: dict, model: RepairListModel.self,isMultipart: true, images: images){ result in
            switch result {
            case .success(let model):
                if let data = model.data {
                    DispatchQueue.main.async {
                        
                    }
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

