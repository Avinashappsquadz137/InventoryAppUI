//
//  SelectDatePopUp.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 16/12/24.
//

import SwiftUI

struct SelectDatePopUp: View {
    @Binding var showPopup: Bool
    let onSubmit: () -> Void // Callback for submit action

    @State private var fromDate: Date = Date()
    @State private var toDate: Date = Date()
    @State private var isFromDatePickerVisible: Bool = false
    @State private var isToDatePickerVisible: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Select Date Range")
                .font(.title)
                .fontWeight(.bold)

            Button(action: {
                isFromDatePickerVisible.toggle()
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

            Button(action: {
                isToDatePickerVisible.toggle()
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
                Button(action: {
                    showPopup = false
                }) {
                    Text("Cancel")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button(action: {
                    print("From Date: \(fromDate), To Date: \(toDate)")
                    onSubmit()
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
        .frame(width: 300)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}