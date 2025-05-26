//
//  QRCodeScannerView.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 24/05/25.
//
import SwiftUI
import AVFoundation

struct QRCodeScannerView: UIViewRepresentable {
    class ScannerView: UIView, AVCaptureMetadataOutputObjectsDelegate {
        var captureSession: AVCaptureSession?
        var previewLayer: AVCaptureVideoPreviewLayer!
        var onCodeScanned: ((String) -> Void)?

        override init(frame: CGRect) {
            super.init(frame: frame)
            initializeCamera()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            initializeCamera()
        }

        func initializeCamera() {
            let session = AVCaptureSession()
            guard let videoDevice = AVCaptureDevice.default(for: .video),
                  let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
                  session.canAddInput(videoInput) else { return }

            session.addInput(videoInput)

            let metadataOutput = AVCaptureMetadataOutput()
            if session.canAddOutput(metadataOutput) {
                session.addOutput(metadataOutput)

                metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
                metadataOutput.metadataObjectTypes = [.qr]
            }

            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            layer.addSublayer(previewLayer)

            session.startRunning()
            self.captureSession = session
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            previewLayer.frame = bounds
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput,
                            didOutput metadataObjects: [AVMetadataObject],
                            from connection: AVCaptureConnection) {
            guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
                  let code = metadataObject.stringValue else { return }

            //AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            onCodeScanned?(code)
        }
    }

    var completion: (String) -> Void

    func makeUIView(context: Context) -> ScannerView {
        let scannerView = ScannerView()
        scannerView.onCodeScanned = completion
        return scannerView
    }

    func updateUIView(_ uiView: ScannerView, context: Context) {}
}
