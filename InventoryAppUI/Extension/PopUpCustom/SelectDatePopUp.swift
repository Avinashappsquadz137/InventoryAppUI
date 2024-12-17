//
//  SelectDatePopUp.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 16/12/24.
//

import SwiftUI

struct SelectDatePopUp: View {
    @Binding var showPopup: Bool  // Binding to control popup visibility
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Date")
                .font(.title)
                .fontWeight(.bold)
            
            Text("This is where you can add your custom popup content.")
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                showPopup = false  // Dismiss popup
            }) {
                Text("Close")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .frame(width: 300) // Adjust popup size
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
    }
}
