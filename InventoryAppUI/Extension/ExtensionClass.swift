//
//  ContentView.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 12/12/24.
//

import SwiftUI


extension Color {
    //static let brightOrange = Color(red: 0.0/255.0, green: 127.0/255.0, blue: 255.0/255.0)
    static let brightOrange = Color(red: 255.0/255.0, green: 127.0/255.0, blue: 0.0/255.0)
  
}

var inventoryDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    return formatter
}

func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"  //yyyy-MM-dd
    return formatter.string(from: date)
}
 
func formattedDate(from dateString: String, fromFormat: String, toFormat: String) -> String? {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = fromFormat
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = toFormat
    
    if let date = inputFormatter.date(from: dateString) {
        return outputFormatter.string(from: date)
    } else {
        return nil
    }
}

func convertToDate(_ dateString: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy" 
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale.current
    return formatter.date(from: dateString)
}
