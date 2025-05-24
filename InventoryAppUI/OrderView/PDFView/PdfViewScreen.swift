//
//  PdfViewScreen.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 24/05/25.
//

import SwiftUI
import WebKit
import PDFKit

struct PdfViewScreen: View {
    
    let tempID: String
    
    @State private var pdfURL: URL?
    @State private var isLoading: Bool = true
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            if let pdfURL = pdfURL {
                WebView(url: pdfURL)
                    .edgesIgnoringSafeArea(.all)
            } else if isLoading {
                ProgressView("Loading PDF...")
            } else {
                Text("Failed to load PDF")
                    .foregroundColor(.red)
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        orderView()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                            .padding()
                    }
                }
                Spacer()
                if let pdfURL = pdfURL {
                    HStack {
                        Spacer()
                        Button(action: {
                            Task {
                                let urlString = pdfURL.absoluteString
                                if let localURL = await downloadPDF(urlstring: urlString) {
                                    print("Downloaded file at: \(localURL)")
                                    DispatchQueue.main.async {
                                        ToastManager.shared.show(message: "PDF downloaded to Files app")
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        ToastManager.shared.show(message: "Failed to download PDF")
                                    }
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: "arrow.down.circle.fill")
                                Text("Download")
                            }
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.bottom, 20)
                            .padding(.trailing, 20)
                        }
                    }
                }
            }
            .overlay(ToastView())
        }
        .onAppear {
            fetchPDF()
        }
        .navigationTitle("PDF View")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
    func orderView() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.rootViewController = UIHostingController(rootView: MAinTabbarVC().environment(\.colorScheme, .light))
            window.makeKeyAndVisible()
        }
    }
    private func fetchPDF() {
        let dict: [String: Any] = [
            "temp_id": tempID,
            "emp_code": UserDefaultsManager.shared.getEmpCode()
        ]
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.submitChallanMaster,
            method: .post,
            param: dict,
            model: SubmitChallan.self
        ) { result in
            switch result {
            case .success(let model):
                if let urlString = model.data,
                   let encoded = (Constant.BASEURL + "Files/" + urlString)
                    .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                   let finalURL = URL(string: encoded) {
                    DispatchQueue.main.async {
                        self.pdfURL = finalURL
                        self.isLoading = false
                    }
                } else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        ToastManager.shared.show(message: "No valid PDF URL received.")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    ToastManager.shared.show(message: "API error: \(error.localizedDescription)")
                }
            }
        }
    }
 
    private func downloadPDF(urlstring: String) async -> URL? {
        guard let url = URL(string: urlstring) else {
            print("Invalid URL string")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Bad response")
                return nil
            }
            
            let documentsUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
            
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("File already exists at path: \(destinationUrl.path)")
                return destinationUrl
            }
            
            try data.write(to: destinationUrl)
            return destinationUrl
        } catch {
            print("Error downloading PDF: \(error.localizedDescription)")
            return nil
        }
    }
    
}


