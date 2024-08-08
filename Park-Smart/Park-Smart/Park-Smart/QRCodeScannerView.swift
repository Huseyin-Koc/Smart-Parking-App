//
//  QRCodeScannerView.swift
//  Park-Smart
//
//  Created by Hüseyin Koç on 5.05.2024.
//

import SwiftUI
import AVFoundation

struct QRCodeScannerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var scannedCode: String?

    func makeUIViewController(context: Context) -> QRScannerViewController {
        let viewController = QRScannerViewController()
        viewController.delegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: QRScannerViewController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, QRScannerViewControllerDelegate {
        var parent: QRCodeScannerView

        init(_ parent: QRCodeScannerView) {
            self.parent = parent
        }

        func codeDidFind(_ code: String) {
            parent.scannedCode = code
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
