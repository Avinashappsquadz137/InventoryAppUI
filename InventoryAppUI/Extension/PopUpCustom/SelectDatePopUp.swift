//
//  SelectDatePopUp.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 16/12/24.
//

import SwiftUI

struct SelectDatePopUp: View {
    @Binding var showPopup: Bool  // Binding to control popup visibility
    
    @State private var fromDate: Date = Date()  // State for 'From Date'
    @State private var toDate: Date = Date()    // State for 'To Date'
    
    @State private var isFromDatePickerVisible: Bool = false  // Show/Hide From Date Picker
    @State private var isToDatePickerVisible: Bool = false    // Show/Hide To Date Picker
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Date Range")
                .font(.title)
                .fontWeight(.bold)
            
            // From Date Button
            Button(action: {
                isFromDatePickerVisible.toggle() // Toggle visibility of From Date Picker
                isToDatePickerVisible = false
            }) {
                Text("From Date: \(formattedDate(fromDate))")
                    .font(.headline)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
            }
            
            // Conditional From Date Picker
            if isFromDatePickerVisible {
                DatePicker(
                    "",
                    selection: $fromDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
                .padding(10)
            }
            
            // To Date Button
            Button(action: {
                isToDatePickerVisible.toggle() // Toggle visibility of To Date Picker
                isFromDatePickerVisible = false
            }) {
                Text("To Date: \(formattedDate(toDate))")
                    .font(.headline)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.1))
                    .foregroundColor(.green)
                    .cornerRadius(8)
            }
            
            // Conditional To Date Picker
            if isToDatePickerVisible {
                DatePicker(
                    "",
                    selection: $toDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
                .padding(10)
            }
            
            HStack(spacing: 15) {
                // Cancel Button
                Button(action: {
                    showPopup = false  // Dismiss popup
                }) {
                    Text("Cancel")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                // Submit Button
                Button(action: {
                    // Handle 'Submit' action (e.g., save selected dates)
                    print("From Date: \(fromDate), To Date: \(toDate)")
                    showPopup = false  // Dismiss popup
                }) {
                    Text("Submit")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding(10)
        .frame(width: 300) // Adjust popup size
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
    }
    
    // Helper function to format dates
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
