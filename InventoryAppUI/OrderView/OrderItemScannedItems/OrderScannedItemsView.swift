//
//  OrderScannedItemsView.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 12/05/25.
//


import SwiftUI
import AudioToolbox

struct OrderScannedItemsView: View {
    let order: ItemDetail
    @Environment(\.presentationMode) var presentationMode
    @State private var scannedItems: [String] = []
    @State private var scannedText: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var selectedItemName: String?
    @State private var scannedCategories: [String] = []
    @State private var scannedCategoryCounts: [String: Int] = [:]
    @State private var navigate = false
    
    var body: some View {
        VStack {
            DataScannerRepresentable(
                shouldStartScanning: .constant(true),
                scannedText: $scannedText,
                dataToScanFor: [.barcode(symbologies: [.qr])]
            )
            .onChange(of: scannedText) { newValue in
                handleScannedText(newValue)
            }
            .frame(height: 300)
            .border(Color.gray, width: 2)
            .padding(.top)
            Divider().padding(.vertical, 8)

            List(order.items, id: \.itemName) { item in
                HStack {
                    VStack(alignment: .leading) {
                        let scannedCount = scannedCategoryCounts[item.category, default: 0]
                        let quantity = Int(item.quantity) ?? 0
                        Text("\(item.itemName) - \(scannedCount)/\(quantity)")
                            .font(.subheadline)
                    }
                    Spacer()
                    if let count = scannedCategoryCounts[item.category],
                       let required = Int(item.quantity),
                       count >= required {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.brightOrange)
                    }
                }
            }
            Spacer()
            NavigationLink(destination: EnterDetailsVC(order: order), isActive: $navigate) {
                       EmptyView()
                   }
                Button(action: {
                    print("All items scanned: \(scannedItems)")
                    navigate = true
                }) {
                    Text("SUBMIT")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.brightOrange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(10)
        }
        .navigationTitle("Scan Items")
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
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .overlay(ToastView())
    }
    
    private func playBeepSound() {
        AudioServicesPlaySystemSound(SystemSoundID(1057))
    }
    private func handleScannedText(_ newValue: String) {
        guard !newValue.isEmpty else { return }
        print("Scanned QR code: \(newValue)")
        playBeepSound()

        let components = newValue.components(separatedBy: "_")
        guard components.count > 1 else {
            alertMessage = "Invalid QR code format."
            showAlert = true
            scannedText = ""
            return
        }

        guard let scannedItemName = components.last, !scannedItemName.isEmpty else {
            alertMessage = "Invalid QR code format."
            showAlert = true
            scannedText = ""
            return
        }
        guard let matchingItem = order.items.first(where: { $0.itemName == scannedItemName }),
              let quantity = Int(matchingItem.quantity) else {
            alertMessage = "This item is not in the order list."
            showAlert = true
            scannedText = ""
            return
        }

        let currentCount = scannedCategoryCounts[scannedItemName, default: 0]

        if currentCount >= quantity {
            alertMessage = "This item has already been scanned \(quantity) times."
            showAlert = true
        } else {
            scannedCategoryCounts[scannedItemName] = currentCount + 1

            if scannedCategoryCounts[scannedItemName] == quantity {
                selectedItemName = matchingItem.itemName

                if let name = selectedItemName, !scannedItems.contains(name) {
                    scannedItems.append(name)
                }
            }
        }

        scannedText = ""
    }

}
