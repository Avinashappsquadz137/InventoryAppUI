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
    @State private var isSubmitting = false
    @State private var itemRepair: [ItemRepairById] = []
    @Environment(\.dismiss) private var dismiss
//    init(product: RepairList?) {
//        self.product = product
//        getItemRepairById()
//    }
    
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
//                        ImageUploadSection(
//                            title: "Damage Item Photo",
//                            selectedImage: $selectedImageDamage,
//                            isImagePickerPresented: $isImagePickerPresented,
//                            isPickingForDamage: $isPickingForDamage,
//                            isCamera: $isCamera,
//                            isDamage: true
//                        )
                    }
                    
                    Button(action: submitRepairDetails) {
                        Text("Add Product Repair Detail")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.brightOrange)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            .navigationTitle("Add Repair Details")
            .onAppear {
                getItemRepairById()
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(
                    image: isPickingForDamage ? $selectedImageDamage : $selectedImageReceiptBill,
                    isCamera: isCamera
                )
            }
        }
        .overlay(ToastView())
    }
    
    func getItemRepairById() {
            guard let repairID = product?.iTEM_REPAIR_ID else { return }
            
            let dict: [String: Any] = [
                "emp_code": "1",
                "repair_id": repairID
            ]
            
            ApiClient.shared.callmethodMultipart(apiendpoint: Constant.getItemRepairById, method: .post, param: dict, model: GetItemRepairByIdModel.self) { result in
                switch result {
                case .success(let model):
                    if let data = model.data {
                        DispatchQueue.main.async {
                            self.itemRepair = [data]
                            self.repairAddress = data.repair_address ?? ""
                            self.mobileNumber = data.receipt_center_phoneno ?? ""
                            self.repairCenterPhone = data.receipt_center_phoneno ?? ""
                            self.price = data.repairing_price ?? ""
                            self.remarks = data.remarks ?? ""
                            if let issueDateString = data.issue_date {
                                self.issueDate = convertToDate(issueDateString) ?? Date()
                            }
                            
                            if let repairingDateString = data.repair_date {
                                self.repairingDate = convertToDate(repairingDateString) ?? Date()
                            }
                            if let receiptBillURL = data.receipt_bill, !receiptBillURL.isEmpty {
                                loadImage(from: receiptBillURL) { image in
                                    DispatchQueue.main.async {
                                        self.selectedImageReceiptBill = image
                                    }
                                }
                            }

                        }
                    } else {
                        print("No data received")
                    }
                case .failure(let error):
                    print("Error fetching repair details:", error)
                }
            }
        }
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: "\(ApiRequest.Url.serverURL)" + urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                print("Failed to load image:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
            }
        }.resume()
    }

    func submitRepairDetails() {
        guard !isSubmitting else { return } 
            isSubmitting = true
          guard let productID = product?.iTEM_MASTER_ID, let repairID = product?.iTEM_REPAIR_ID else {
              print("Invalid product or repair ID")
              return
          }
          
          let dict: [String: Any] = [
              "emp_code": "1",
              "product_id": productID,
              "repair_address": repairAddress,
              "phone_no": mobileNumber,
              "repair_price": price,
              "issue_date": formattedDate(issueDate),
              "repair_date": formattedDate(repairingDate),
              "remarks": remarks,
              "repair_id": repairID
          ]
          
          var images: [String: Data] = [:]
//          
//          if let damageImageData = selectedImageDamage?.jpegData(compressionQuality: 0.7) {
//              images["thumbnail"] = damageImageData
//          }
          if let receiptImageData = selectedImageReceiptBill?.jpegData(compressionQuality: 0.7) {
              images["receipt_bill"] = receiptImageData
          }

          ApiClient.shared.callHttpMethod(apiendpoint: Constant.updateItemRepairDetail, method: .post, param: dict, model: repairDetails.self, isMultipart: true, images: images) { result in
              switch result {
              case .success(let model):
                  if model.data != nil {
                      ToastManager.shared.show(message: model.message ?? "Successfully updated repair details")
                      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                          isSubmitting = false
                          dismiss()
                      }
                  } else {
                      print("No data returned")
                  }
              case .failure(let error):
                  isSubmitting = false
                  print("Error updating repair details:", error)
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
                    .foregroundColor(.brightOrange)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brightOrange, lineWidth: 1))
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

