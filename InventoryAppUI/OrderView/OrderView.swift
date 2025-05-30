//
//  OrderView.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 10/01/25.
//
import SwiftUI

struct OrderView: View {
    @State private var orders: [ItemDetail] = []
    @State private var selectedOrder: ItemDetail? = nil
    @State private var searchText = ""
    private var filteredItems: [ItemDetail] {
        if searchText.isEmpty {
            return orders
        } else {
            return orders.filter {
                $0.clientName.lowercased().contains(searchText.lowercased())
            }
        }
    }
    var body: some View {
        VStack {
            if orders.isEmpty {
                VStack {
                    Image(systemName: "tray.2") 
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .padding()
                    
                    Text("No Orders Available")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.top, 5)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                HStack(spacing: 4) {
                    TextField("Search...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minWidth: 100)

                    Button(action: {
                        withAnimation {
                            searchText = ""
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                    }
                }
                .padding(2)
                List(filteredItems, id: \.tempID) { order in
                    MoreOrderCell(
                        clientName: order.clientName,
                        clientContact: order.personMobileNo,
                        clientLocation: order.toLocation,
                        clientDate: order.showDate,
                        source: "OrderView"
                    ) {
                        print("Open details for \(order.clientName)")
                        selectedOrder = order
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .onAppear {
            getRequestDetail()
        }
        .fullScreenCover(isPresented: Binding<Bool>(
            get: { selectedOrder != nil },
            set: { if !$0 { selectedOrder = nil } }
        )) {
            if let order = selectedOrder {
                NavigationStack {
                    OrderScannedItemsView(order: order)
                }
            }
        }
    }
    
    func getRequestDetail() {
        let dict: [String: Any] = ["emp_code": "SANS-00290"]
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.requestdetailapi,
            method: .post,
            param: dict,
            model: Requestresponsedata.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if let data = model.data {
                        self.orders = data
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
