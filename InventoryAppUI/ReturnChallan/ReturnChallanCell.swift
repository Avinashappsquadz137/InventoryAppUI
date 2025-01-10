//
//  ReturnChallanCell.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 09/01/25.
//

import SwiftUI

struct ReturnChallanCell: View {
    var itemImageURL: String?

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: itemImageURL ?? "")) { image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width / 2 - 20, height: 150)
                    .cornerRadius(8)
            } placeholder: {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width / 2 - 20, height: 150)
                    .foregroundColor(.gray)
                    .cornerRadius(8)
            }
        }
    }
}

