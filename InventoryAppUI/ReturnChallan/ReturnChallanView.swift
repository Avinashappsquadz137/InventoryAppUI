//
//  ReturnChallanView.swiftqrcode.viewfinder
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 09/01/25.
//
import SwiftUI

struct ReturnChallanView: View {
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State private var showDateilScreen = false
    @State var isShowingScanner = false
    @State private var scannedText = ""
    @State private var checkedStates: [String] = []
    let itemTitles = ["Scan QR", "Enter Number"]
    let itemImages = ["qrcode.viewfinder", "number"]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(0..<itemImages.count, id: \.self) { index in
                    ReturnChallanCell(
                        index: index,
                        title: itemTitles[index], imageName: itemImages[index]
                    ) { tappedIndex in
                        print("Tapped on item with index: \(tappedIndex)")
                        if tappedIndex == 0 {
                            isShowingScanner = true
                        } else if tappedIndex == 1 {
                            showDateilScreen = true
                        }
                    }
                }
            }
            .padding()
        }
        .fullScreenCover(isPresented: $isShowingScanner) {
            QRScannerView(isShowingScanner: $isShowingScanner, scannedText: $scannedText)
        }
        .fullScreenCover(isPresented: $showDateilScreen) {
            ReturnChallanByID()
        }
    }
}
