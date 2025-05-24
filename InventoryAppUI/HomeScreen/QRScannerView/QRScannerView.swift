//
//  QRScannerView.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 30/12/24.
//

import SwiftUI
import VisionKit

struct QRScannerView: View {
    @Binding var isShowingScanner: Bool
    @Binding var scannedText: String
    
    @State private var showAddButton: Bool = false 
    
    var body: some View {
        NavigationView {
            VStack {
                if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
                    ZStack {
                        QRCodeScannerView { newValue in
                            scannedText = newValue
                            if !newValue.isEmpty {
                                showAddButton = true
                            }
                        }
                        .frame(width: 300, height: 300)
                        .border(Color.gray, width: 2)
                    }
                    if showAddButton {
                        Button(action: {
                            // Handle "Add Item" button tap
                            print("Scanned Text: \(scannedText)")
                            addQRItemDetail()
                            isShowingScanner = false
                        }) {
                            Text("Add Item")
                                .padding()
                                .background(Color.brightOrange)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.top, 20)
                    }
                } else {
                    Text("Scanner not available or supported")
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("QR Scanner")
            .navigationBarItems(trailing: Button("Close") {
                isShowingScanner = false
            })
        }
    }
    func addQRItemDetail() {
        let parameters: [String: Any] = ["emp_code": "\(UserDefaultsManager.shared.getEmpCode())","item_qr_string": "\(scannedText)"]
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.addToCartByItemQr,
            method: .post,
            param: parameters,
            model: GetAllCartList.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if let data = model.data {
                        
                        print("Fetched items: \(data)")
                    } else {
                        print("No data received")
                    }
                case .failure(let error):
                    print("API Error: \(error)")
                }
            }
        }
    }
}
