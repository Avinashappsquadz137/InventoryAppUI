//
//  ShowScannedItemsView.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 11/01/25.
//

import SwiftUI

struct ShowScannedItemsView: View {
    var body: some View {
        VStack{
            ShowScannedItemsCells(textFieldValue: "sd")
        }
    }
}

#Preview {
    ShowScannedItemsView()
}
