//
//  MoreOrderCell.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 10/01/25.
//

import SwiftUI

struct MoreOrderCell: View {
    let clientName: String
    let clientContact: String
    let clientLocation: String
    let clientDate: String
    let source: String
    var openDetails: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Client Name : \(clientName)")
                    .font(.headline)
                Text("Phone Number : \(clientContact)")
                    .font(.headline)
                Text("Location : \(clientLocation)")
                    .font(.headline)
                Text("Show Date : \(clientDate)")
                    .font(.headline)
            }
            Spacer()
            HStack {
                if source == "SubmitChallanView" {
                    Button(action: openDetails) {
                        
                        Text("OPEN PDF")
                            .font(.callout)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }else {
                    Button(action: openDetails) {
                        
                        Text("OPEN")
                            .font(.callout)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(5)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
    }
}
