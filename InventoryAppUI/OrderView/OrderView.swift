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

    var body: some View {
        VStack {
            if orders.isEmpty {
                Text("No orders available")
                    .foregroundColor(.gray)
            } else {
                List(orders, id: \.tempID) { order in
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
                EnterDetailsVC(order: order)
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
