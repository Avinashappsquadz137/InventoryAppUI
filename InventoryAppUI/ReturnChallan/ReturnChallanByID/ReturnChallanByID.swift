//
//  ReturnChallanByID.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 10/01/25.
//

import SwiftUI

struct ReturnChallanByID: View {
    @State private var textFieldValue: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Enter Challan ID")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                TextField("Enter Challan ID", text: $textFieldValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    print("Button tapped with text: \(textFieldValue)")
                    textFieldValue = ""
                }) {
                    Text("Submit")
                        .font(.headline)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer()
            }
            .padding()
            .modifier(ViewModifiers())
        
            .navigationTitle("Enter Challan ID")
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
        }
    }
}

struct ReturnChallanByID_Previews: PreviewProvider {
    static var previews: some View {
        ReturnChallanByID()
            .previewDevice("iPhone 14")
            .preferredColorScheme(.light)
    }
}
