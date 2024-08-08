import SwiftUI

struct QRCodeScannerView2: View {
    @Binding var scannedCode: String?

    var body: some View {
        VStack {
            if ProcessInfo.processInfo.arguments.contains("-UITest_Mode") {
                // In UI test mode, simulate scanning by setting a mock QR code value
                Text("Scanning...").onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.scannedCode = "MockQRCodeResult"
                    }
                }
            } else {
                // Your actual scanning view logic here
                Text("Real QR Code Scanner")
            }
        }
    }
}
