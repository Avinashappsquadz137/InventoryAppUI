//
//  ReturnChallanCell.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 09/01/25.
//

import SwiftUI

struct ReturnChallanCell: View {
    var index: Int
    var title: String
    var imageName: String // Accept image name (or URL)
    var onTap: (Int) -> Void // Closure to handle the tap action
    var body: some View {
        VStack {
            ZStack {
                Color.brightOrange.opacity(0.2) // Light blue background
                    .cornerRadius(8)
                    .frame(width: UIScreen.main.bounds.width / 2 - 20, height: 150)
                VStack{
                    Image(systemName: imageName) // Use the passed image name
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.brightOrange)
                    Text(title) 
                        .font(.headline)
                }
            }
            .onTapGesture {
                onTap(index) // Call the tap closure with the index
            }
        }
    }
}

#Preview {
    ReturnChallanView()
}
