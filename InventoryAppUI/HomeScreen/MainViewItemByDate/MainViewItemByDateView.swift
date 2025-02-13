//
//  MainViewItemByDateView.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 16/01/25.
//

import SwiftUI
import VisionKit

struct MainViewItemByDateView: View {
    @State private var item: [Items] = []
    @State private var isFromDatePickerVisible: Bool = false
    @State private var isToDatePickerVisible: Bool = false
    
    @State private var showPopup = false
    @State var isShowingScanner = false
    @State private var scannedText = ""
    @State private var checkedStates: [String] = []
    
    @State private var itemCounts: [Int] = []
    @State private var addedToCart: [Bool] = []
    @State private var searchText: String = ""
    
    @State private var isDateSelected = false
    
    @State var fromDate: Date = UserDefaultsManager.shared.getFromDate() ?? Date()
    @State var toDate: Date = UserDefaultsManager.shared.getToDate() ?? Date()
    
    var filteredItems: [Items] {
        if searchText.isEmpty {
            return item
        } else {
            return item.filter {
                $0.iTEM_NAME?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }
    }
    
    var body: some View {
        ZStack{
            VStack {
                HStack {
                    if !item.isEmpty {
                        TextField("Search items...", text: $searchText)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        
                        Button(action: {
                            showPopup = true
                        }) {
                            Image(systemName: "calendar.badge.plus")
                                .foregroundColor(.brightOrange)
                                .font(.system(size: 30))
                        }
                    }
                }
                .padding(10)
                Spacer()
//                if item.isEmpty {
//                    Text("Select Date For Items")
//                        .font(.title)
//                        .bold()
//                    Button(action: {
//                        showPopup = true
//                    }) {
//                        Image(systemName: "calendar.badge.plus")
//                            .foregroundColor(.brightOrange)
//                            .font(.system(size: 100))
//                    }
//                }else {
                    List(filteredItems.indices, id: \.self) { index in
                        ItemDetailCell(
                            itemMasterId: filteredItems[index].iTEM_MASTER_ID,
                            itemName: filteredItems[index].iTEM_NAME ?? "Unknown",
                            itemDetail: "Brand: \(filteredItems[index].bRAND ?? "Unknown"), Model: \(filteredItems[index].mODEL_NO ?? "Unknown")",
                            itemDesc: filteredItems[index].currently_available,
                            itemCounts: $itemCounts[index], // Pass as binding
                            isAddToCartButtonVisible: Binding(
                                get: { addedToCart[index] ? 1 : 0 },
                                set: { newValue in
                                    addedToCart[index] = newValue == 1
                                }
                            ),
                            isCheckboxVisible: false,
                            itemImageURL: filteredItems[index].iTEM_THUMBNAIL,
                            onAddToCart: {
                                addedToCart[index] = true
                                print("Added to cart: \(filteredItems[index].iTEM_NAME ?? "Unknown")")
                            },
                            onCountChanged: { newCount in
                                itemCounts[index] = newCount
                                print("Updated count for \(filteredItems[index].iTEM_NAME ?? "Unknown"): \(newCount)")
                            },
                            hideDeleteButton: true, onDelete: {}, onCheckUncheck: {}
                        )}
                    .listStyle(PlainListStyle())
                    .onTapGesture {
                        if isDateSelected {
                            showPopup = false
                        }else {
                            showPopup = true
                        }
                    }
                //}
                Spacer()
            }
            if showPopup {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showPopup = false
                        }
                    SelectDatePopUp(
                        showPopup: $showPopup,
                        onSubmit: {
                            saveDatesToUserDefaults()
                            getItemByDateDetail()
                            isDateSelected = true
                        }, checkedStates: checkedStates.map { $0 },
                        fromDate: $fromDate,
                        toDate: $toDate
                    )
                    
                }
                .transition(.opacity)
                .animation(.easeInOut, value: showPopup)
            }
        }
        .onAppear {
            getItemByDateDetail()
        }
        
    }
    
    
    func saveDatesToUserDefaults() {
        UserDefaultsManager.shared.saveFromDate(fromDate)
        UserDefaultsManager.shared.saveToDate(toDate)
    }
    
    func getItemByDateDetail() {
        let parameters: [String: Any] = [
            "emp_code": "1",
            "to_date": "\(formattedDate(toDate))",
            "from_date" : "\(formattedDate(fromDate))"]
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getItemByDate,
            method: .post,
            param: parameters,
            model: GetItemByDate.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if let data = model.data {
                        self.item = data
                        self.addedToCart = Array(repeating: false, count: data.count)
                        self.itemCounts = Array(repeating: 1, count: data.count)
                        showPopup = false
                        print("Fetched items: \(data)")
                    } else {
                        print("No data received")
                    }
                case .failure(let error):
                    print("API Error: \(error)")
                }
            }
        }
    }
}
