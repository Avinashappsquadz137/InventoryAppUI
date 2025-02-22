//
//  SelectDatePopUp.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 16/12/24.
//

import SwiftUI

struct SelectDatePopUp: View {
    @Binding var showPopup: Bool
    let onSubmit: () -> Void 
    let checkedStates: [String]
    
    @Binding var fromDate: Date
    @Binding var toDate: Date
    
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
                    .background(Color.brightOrange.opacity(0.1))
                    .foregroundColor(.brightOrange)
                    .cornerRadius(8)
            }

            if isFromDatePickerVisible {
                DatePicker(
                    "",
                    selection: Binding(
                        get: { fromDate },
                        set: { newValue in
                            fromDate = newValue
                            if toDate < fromDate {
                                toDate = fromDate
                            }
                            isFromDatePickerVisible = false
                        }
                    ),
                    in: Date()...,
                    displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .tint(Color.brightOrange)
                .background(Color.brightOrange.opacity(0.2))
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
                    .background(Color.brightOrange.opacity(0.1))
                    .foregroundColor(.brightOrange)
                    .cornerRadius(8)
            }
            
            if isToDatePickerVisible {
                DatePicker(
                    "",
                    selection: Binding(
                        get: { toDate },
                        set: { newValue in
                            toDate = newValue
                            if toDate < fromDate {
                                fromDate = toDate
                            }
                            isToDatePickerVisible = false
                           
                        }
                    ),
                    in: fromDate...,
                    displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .tint(Color.brightOrange)
                .background(Color.brightOrange.opacity(0.2))
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
                    Text("OK")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.brightOrange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
        .onAppear {
            if Calendar.current.isDate(fromDate, equalTo: Date(), toGranularity: .day) == false {
                fromDate = Date()
            }
            
        }
    }
}
