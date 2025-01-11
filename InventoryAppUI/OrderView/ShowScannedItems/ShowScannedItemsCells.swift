//
//  ShowScannedItemsCells.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 11/01/25.
//

import SwiftUI
import VisionKit

struct ShowScannedItemsCells: View {
    
    @State var textFieldValue: String
    @State var isShowingScanner = false
    @State private var scannedText = ""
    @State private var isChecked: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("JBL")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Max Quantity :")
                        .font(.headline)
                    Text("Selected Quantity :")
                        .font(.headline)
                    Text("Total Rent : ")
                        .font(.headline)
                    Text("Per Pices Rent : \(textFieldValue)")
                        .font(.headline)
                }
                Spacer()
                Button(action: {
                    if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
                        isShowingScanner = true
                    } else {
                        print("Scanner is not supported or available")
                    }
                }){
                    Image(systemName: "qrcode.viewfinder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())
                
            }
            VStack {
                HStack {
                    TextField("Rent Per Items", text: $textFieldValue)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("Include GST")
                        .font(.headline)
                    Button(action: {
                     
                        print("Checkbox tapped: \(isChecked ? "Checked" : "Unchecked")")
                    }) {
                        Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 30))
                            .foregroundColor(isChecked ? .green : .gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                Button(action: {
                    print("Button tapped with text: \(textFieldValue)")
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
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
        .fullScreenCover(isPresented: $isShowingScanner) {
            QRScannerView(isShowingScanner: $isShowingScanner, scannedText: $scannedText)
                .onDisappear {
                   
                }
        }
    }
}

#Preview {
    ShowScannedItemsCells(textFieldValue: "")
}
