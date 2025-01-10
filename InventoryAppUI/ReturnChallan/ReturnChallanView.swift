//
//  ReturnChallanView.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 09/01/25.
//

import SwiftUI


struct ReturnChallanView: View {
    let itemImageURLs = [
        "https://fastly.picsum.photos/id/1023/200/200.jpg?hmac=MtNMS39i8o8sE6PiXNwABDxNtK4niBxaZWoX5KY3cyg",
        "https://picsum.photos/200"
    ]

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(itemImageURLs, id: \.self) { imageURL in
                    ReturnChallanCell(itemImageURL: imageURL)
                }
            }
            .padding()
        }
    }
}

#Preview {
    ReturnChallanView()
}
