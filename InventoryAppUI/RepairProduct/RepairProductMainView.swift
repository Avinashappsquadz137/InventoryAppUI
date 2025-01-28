//
//  RepairProductMainView.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 27/01/25.
//

import SwiftUI

struct RepairProductMainView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Repair Product View")
            }
            .padding()
            .modifier(ViewModifiers())
            .navigationTitle("Enter Challan ID")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        redirectToMainTabbar()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                }
            }
            .overlay(ToastView())
            
        }
    }
    func redirectToMainTabbar() {
        DispatchQueue.main.async {
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: MAinTabbarVC())
                window.makeKeyAndVisible()
            }
        }
    }
}
