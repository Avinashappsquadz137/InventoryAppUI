//
//  UploadDocumentView.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 10/05/25.
//
import SwiftUI
import UniformTypeIdentifiers

struct UploadDocumentView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showPicker = false
    @State private var selectedFileURL: URL?

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                Button(action: {
                    showPicker = true
                }) {
                    HStack {
                        Image(systemName: "doc.badge.plus")
                        Text("Pick Excel File (.xlsx)")
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                if let url = selectedFileURL {
                    Text("Selected File: \(url.lastPathComponent)")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    QuickLookPreview(fileURL: url)
                        .frame(maxHeight: UIScreen.main.bounds.height * 0.5)
                }

                Spacer()
                if selectedFileURL != nil {
                    Button(action: {
                        uploadExcelApi()
                    }) {
                        Text("Submit Excel File")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.brightOrange)
                            .cornerRadius(10)
                    }
                    
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Upload your document here")
                        .font(.headline)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                }
            }
            .sheet(isPresented: $showPicker) {
                DocumentPicker(
                    supportedTypes: [UTType(filenameExtension: "xlsx")!]
                ) { url in
                    selectedFileURL = url
                }
            }
        }
        .overlay(ToastView())
    }
    func uploadExcelApi() {
        guard let fileURL = selectedFileURL else {
            print("No file selected.")
            return
        }

        var dict = [String: Any]()
        dict["emp_code"] = "\(UserDefaultsManager.shared.getEmpCode())"

        do {
            let fileData = try Data(contentsOf: fileURL)
            
            ApiClient.shared.callHttpMethod(
                apiendpoint: Constant.uploadExcelForEvent,
                method: .post,
                param: dict,
                model: GetSuccessMessage.self,
                isMultipart: true,
                files: ["excel_file": (data: fileData, fileName: fileURL.lastPathComponent, mimeType: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")]
            ) { result in
                switch result {
                case .success(let model):
                    if model.status == true {
                        ToastManager.shared.show(message: model.message ?? "Successfully uploaded Excel file")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            dismiss()
                        }
                    } else {
                        print("Upload failed: \(model.message ?? "Unknown error")")
                    }
                case .failure(let error):
                    print("Upload error:", error)
                }
            }
            
        } catch {
            print("Failed to read file data:", error)
        }
    }

}


struct GetSuccessMessage: Codable {
    let status: Bool?
    let message: String?
    let data: [String]?
    let error: [String]?

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case data
        case error
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([String].self, forKey: .data)
        
        // Handle "error" as either a string or an array of strings
        if let errorArray = try? values.decodeIfPresent([String].self, forKey: .error) {
            error = errorArray
        } else if let errorString = try? values.decodeIfPresent(String.self, forKey: .error) {
            error = [errorString]
        } else {
            error = nil
        }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    var supportedTypes: [UTType]
    var onDocumentPicked: (URL) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onDocumentPicked: onDocumentPicked)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var onDocumentPicked: (URL) -> Void

        init(onDocumentPicked: @escaping (URL) -> Void) {
            self.onDocumentPicked = onDocumentPicked
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let url = urls.first {
                onDocumentPicked(url)
            }
        }
    }
}
import QuickLook

struct QuickLookPreview: UIViewControllerRepresentable {
    let fileURL: URL

    func makeCoordinator() -> Coordinator {
        Coordinator(fileURL: fileURL)
    }

    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) {}

    class Coordinator: NSObject, QLPreviewControllerDataSource {
        let fileURL: URL

        init(fileURL: URL) {
            self.fileURL = fileURL
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            1
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            fileURL as NSURL
        }
    }
}
