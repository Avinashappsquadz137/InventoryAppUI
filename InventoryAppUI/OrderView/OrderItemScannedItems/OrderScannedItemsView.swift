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
    private var allItemsScanned: Bool {
        for item in order.items {
            guard let requiredQty = Int(item.quantity) else { return false }
            let scannedQty = scannedCategoryCounts[item.itemName, default: 0]
            if scannedQty < requiredQty {
                return false
            }
        }
        return true
    }

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
                        let scannedCount = scannedCategoryCounts[item.itemName, default: 0]
                        let quantity = Int(item.quantity) ?? 0
                        Text("\(item.itemName) - \(scannedCount)/\(quantity)")
                            .font(.subheadline)
                    }
                    Spacer()
                    if let count = scannedCategoryCounts[item.itemName],
                       let required = Int(item.quantity),
                       count >= required {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.brightOrange)
                    }
                }
            }
            Spacer()
            NavigationLink(destination: EnterDetailsVC(scannedItems: $scannedItems, order: order), isActive: $navigate) {
                       EmptyView()
                   }
                Button(action: {
                    print("All items scanned: \(scannedItems)")
                    navigate = true
                }) {
                    Text("NEXT")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(allItemsScanned ? Color.brightOrange : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!allItemsScanned)
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
        let normalizedScanned = newValue.replacingOccurrences(of: "-", with: " ").lowercased()
        guard let matchingItem = order.items.first(where: {
            normalizedScanned.contains($0.itemName.lowercased())
        }), let quantity = Int(matchingItem.quantity) else {
            alertMessage = "This item is not in the order list."
            showAlert = true
            scannedText = ""
            return
        }

        let itemName = matchingItem.itemName
        let currentCount = scannedCategoryCounts[itemName, default: 0]
        scannedCategoryCounts[itemName] = currentCount + 1

        if scannedCategoryCounts[itemName] == quantity {
            selectedItemName = itemName
            if !scannedItems.contains(itemName) {
                scannedItems.append(newValue)
            }
        }
        scannedText = ""
    }
}
