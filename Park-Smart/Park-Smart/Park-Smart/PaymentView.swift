import SwiftUI

struct PaymentView: View {
    var startDate: Date?
    var pricePerHour: Double
    
    @State private var cardName: String = ""
    @State private var cardNumber: String = ""
    @State private var lastDate: String = ""
    @State private var cvv: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            Text("Complete Your Payment")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding(.top, 20)

            if let startDate = startDate {
                let endDate = Date()
                let parkedDuration = Calendar.current.dateComponents([.minute], from: startDate, to: endDate)
                let hoursParked = Double(parkedDuration.minute ?? 0) / 60
                let totalPrice = hoursParked * pricePerHour

                Group {
                    Text("Parking Duration: \(String(format: "%.2f", hoursParked)) hours")
                    Text("Total Cost: \(String(format: "%.2f", totalPrice))TL")
                }
                .font(.headline)
                .foregroundColor(.black)
                .padding()
            } else {
                Text("No parking duration available.")
                    .foregroundColor(.red)
                    .padding()
            }
            
            TextField("Name of Cardholder", text: $cardName)
                .keyboardType(.namePhonePad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.white)
                .onReceive(cardName.publisher.collect()) {
                    self.cardName = String($0.prefix(30))
                }
            
            TextField("Card Number", text: $cardNumber)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.white)
                .onReceive(cardNumber.publisher.collect()) {
                    self.cardNumber = String($0.prefix(16)).filter("0123456789".contains)
                }
            
            TextField("MM/YY", text: $lastDate)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.white)
                .onReceive(lastDate.publisher.collect()) {
                    var filtered = String($0.prefix(4)).filter("0123456789/".contains)
                    if filtered.count == 2 && !filtered.contains("/") && lastDate.count < filtered.count {
                        filtered += "/"
                    }
                    self.lastDate = filtered

                }
            
            SecureField("CVV", text: $cvv)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.white)
                .onReceive(cvv.publisher.collect()) {
                    self.cvv = String($0.prefix(3)).filter("0123456789".contains)
                }

            Button("Pay") {
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(PayButtonStyle())
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white).shadow(radius: 10))
        .padding()
    }
}

struct PayButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentView(startDate: Date().addingTimeInterval(-3600 * 5), pricePerHour: 2.5)
    }
}
