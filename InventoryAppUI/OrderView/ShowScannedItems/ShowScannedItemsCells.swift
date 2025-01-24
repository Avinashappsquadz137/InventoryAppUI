//
//  ShowScannedItemsCells.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 11/01/25.
//

import SwiftUI
import VisionKit

struct ShowScannedItemsCells: View {
    
    @Binding var textFieldValue: String
    @State var isShowingScanner = false
    @Binding var scannedText : String
    @State private var scannedItems: [String] = []
    @State private var isChecked: Bool = false
    @State var itemName: String
    @State var itemQuantity: String
    @State var itemCategory: String
    
    @State var itemPerPrice: String
    @State private var scanCount = 0
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var onUpdateTotalRent: (Int) -> Void
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(itemName)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text("Max Quantity :\(itemQuantity)")
                        .font(.headline)
                    Text("Selected Quantity : \(scanCount)")
                        .font(.headline)
                    let itemTotalRent = (Int(scanCount)) * (Int(textFieldValue) ?? 0)
                    Text("Total Rent: \(itemTotalRent)")
                        .font(.headline)
                    Text("Per Pices Rent : \(textFieldValue)")
                        .font(.headline)
                    
                }
                Spacer()
                Button(action: {
                    if scanCount < (Int(itemQuantity) ?? 0) {
                        if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
                            isShowingScanner = true
                        } else {
                            print("Scanner is not supported or available")
                        }
                    } else {
                        print("Scan limit reached")
                    }
                }){
                    Image(systemName: "qrcode.viewfinder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(scanCount < (Int(itemQuantity) ?? 0) ? .blue : .gray)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(scanCount >= (Int(itemQuantity) ?? 0))
                
            }
            VStack {
                HStack {
                    TextField("Rent Per Items", text: $textFieldValue)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                Button(action: {
                    print("Button tapped with text: \(textFieldValue)")
                    let totalRent = (scanCount * (Int(textFieldValue) ?? 0))
                    onUpdateTotalRent(totalRent)
                    textFieldValue = ""
                }) {
                    Text("SHOW SCANNED ITEMS")
                        .font(.headline)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Wrong Product"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .fullScreenCover(isPresented: $isShowingScanner) {
            QRScannerView(isShowingScanner: $isShowingScanner, scannedText: $scannedText)
                .onDisappear {
                    if !scannedText.isEmpty {
                        let components = scannedText.split(separator: "_")
                        if components.count > 1 {
                            let extractedValue = String(components[1])
                            print("Scanned text: \(extractedValue), Total scans: \(scanCount)")
                            if extractedValue == itemCategory {
                                scanCount += 1
                                scannedItems.append(scannedText)
                            }
                            if extractedValue != itemCategory {
                                alertMessage = "This is the wrong product! Expected: \(itemCategory), but scanned: \(extractedValue)."
                                showAlert = true
                            }
                        }
                        scannedText = ""
                    }
                }
        }
    }
}
