//
//  SubmitView.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 12/12/24.
//

import SwiftUI
import UIKit

struct SubmitView: View {
    @State  var orderPDF: URL?
    @State private var isDownloading = false
    @State private var showDocument = false

    var body: some View {
        VStack(spacing: 20) {
            if let pdfURL = orderPDF {
                Button(action: {
                    Task {
                        await downloadPDF()
                        showDocument = true
                    }
                }) {
                    Text("View/Download PDF")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showDocument) {
                    DocumentPreviewView(fileURL: pdfURL)
                }
                .disabled(isDownloading)
            }
        }
        .padding()
    }
    
    func downloadPDF() async {
        isDownloading = true
        defer { isDownloading = false }
        guard let url = orderPDF else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Save the PDF to the documents directory
            let fileURL = URL.documentsDirectory.appending(path: "orderPDF.pdf")
            try data.write(to: fileURL)
            
            // Update the state to allow viewing the downloaded PDF
            orderPDF = fileURL
            print("PDF downloaded to: \(fileURL)")
        } catch {
            print("Failed to download PDF: \(error)")
        }
    }
}

struct DocumentPreviewView: UIViewControllerRepresentable {
    let fileURL: URL
    
    func makeUIViewController(context: Context) -> UIDocumentInteractionControllerViewController {
        return UIDocumentInteractionControllerViewController(fileURL: fileURL)
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentInteractionControllerViewController, context: Context) {}
}

extension URL {
    static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
class UIDocumentInteractionControllerViewController: UIViewController {
    private var documentInteractionController: UIDocumentInteractionController?
    
    init(fileURL: URL) {
        super.init(nibName: nil, bundle: nil)
        documentInteractionController = UIDocumentInteractionController(url: fileURL)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        documentInteractionController?.delegate = self
        if let documentInteractionController = documentInteractionController {
            DispatchQueue.main.async {
                documentInteractionController.presentPreview(animated: true)
            }
        }
    }
}

extension UIDocumentInteractionControllerViewController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        dismiss(animated: true, completion: nil)
    }
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
