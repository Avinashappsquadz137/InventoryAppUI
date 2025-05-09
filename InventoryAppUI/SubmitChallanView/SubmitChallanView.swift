//
//  SubmitChallanView.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 17/01/25.
//

import SwiftUI

struct SubmitChallanView: View {
    @State private var orders: [SubmitChallanItem] = []
    @State private var selectedPDF: SubmitChallanItem? = nil
    @State var isShowingPDF = false
    @State var selectedPDFURL: URL?
    
    var body: some View {
        VStack {
            if orders.isEmpty {
                VStack {
                    Image(systemName: "tray.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                    Text("No Data Available")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                }
            } else {
                List(orders, id: \.tEMP_ID) { order in
                    MoreOrderCell(
                        clientName: order.cLIENT_NAME ?? "Unknown",
                        clientContact: order.cONTACT_PERSON ?? "N/A",
                        clientLocation: order.cONTACT_PERSON ?? "N/A",
                        clientDate: order.sHOW_DATE ?? "N/A",
                        source: "SubmitChallanView"
                    ) {
                        print("Open details for \(order.cHALLAN_DETAIL ?? "Unknown")")
                        selectedPDF = order
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .onAppear {
            getInventoryDetail()
        }
        .sheet(isPresented: Binding<Bool>(
            get: { selectedPDF != nil },
            set: { if !$0 { selectedPDF = nil } }
        )) {
            if let challanDetail = selectedPDF?.cHALLAN_DETAIL,
               let orderPDFURL = URL(string: "\(Constant.BASEURL)/Files/\(challanDetail)") {
                SubmitView(orderPDF: orderPDFURL)
            }
        }
    }
    
    func getInventoryDetail() {
        let parameters: [String: Any] = ["emp_code": UserDefaultsManager.shared.getEmpCode(), "type": "1"]
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getInventoryDetail,
            method: .post,
            param: parameters,
            model: SubmitChallanModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if let data = model.data {
                        self.orders = data
                    } else {
                        print("No data received")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

