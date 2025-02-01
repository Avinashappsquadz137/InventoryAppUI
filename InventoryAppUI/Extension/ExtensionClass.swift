//
//  ContentView.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 12/12/24.
//

import SwiftUI


extension Color {
    static let lightblueColor = Color(red: 85.0/255.0, green: 84.0/255.0, blue: 166.0/255.0, opacity: 1.0)
    static let royalBlue = Color(red: 65.0/255.0, green: 105.0/255.0, blue: 225.0/255.0, opacity: 1.0)
    static let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    static let brightOrange = Color(red: 255.0/255.0, green: 127.0/255.0, blue: 0.0/255.0)
  
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
