import SwiftUI
import MapKit
import CoreLocation

// Location manager to handle real-time location updates
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        location = newLocation.coordinate
    }
}

// View that handles the display and interaction with parking spots
struct ContentView: View {
    @ObservedObject var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.0082, longitude: 28.9784),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var showingScanner = false
    @State private var showingDetails = false
    @State private var selectedSpot: ParkingSpot?
    @State private var scannedCode: String?
    @State private var address = ""
    @State private var showingPayment = false
    @State private var currentStartDate: Date?
    @State private var currentPricePerHour: Double = 2.34
    

    @State private var parkingSpots = [
        ParkingSpot(coordinate: CLLocationCoordinate2D(latitude: 41.0343, longitude: 28.9777), name: "Kadıköy İskele Otoparkı", isOccupied: true, startDate: Date().addingTimeInterval(-86400 * Double.random(in: 1...30))),
        ParkingSpot(coordinate: CLLocationCoordinate2D(latitude: 41.0289, longitude: 29.0669), name: "Üsküdar Sahil Parkı", isOccupied: false, startDate: nil),
        ParkingSpot(coordinate: CLLocationCoordinate2D(latitude: 41.0138, longitude: 28.9496), name: "Aksaray Yenikapı Otoparkı", isOccupied: false, startDate: nil),
        ParkingSpot(coordinate: CLLocationCoordinate2D(latitude: 41.0054, longitude: 28.9768), name: "Sultanahmet Meydanı Parkı", isOccupied: false, startDate: nil),
        ParkingSpot(coordinate: CLLocationCoordinate2D(latitude: 41.0012, longitude: 29.0142), name: "Karaköy İskele Parkı", isOccupied: true, startDate: Date().addingTimeInterval(-86400 * Double.random(in: 1...30))),
        ParkingSpot(coordinate: CLLocationCoordinate2D(latitude: 41.0123, longitude: 28.9733), name: "Taksim Gezi Parkı Yanı", isOccupied: false, startDate: nil),
        ParkingSpot(coordinate: CLLocationCoordinate2D(latitude: 41.0497, longitude: 29.0219), name: "Beşiktaş Sahil Parkı", isOccupied: false, startDate: nil),
        ParkingSpot(coordinate: CLLocationCoordinate2D(latitude: 40.9870, longitude: 29.0245), name: "Moda Sahili Otoparkı", isOccupied: false, startDate: nil),
        ParkingSpot(coordinate: CLLocationCoordinate2D(latitude: 41.0677, longitude: 28.9405), name: "Cihangir Mahallesi Otoparkı", isOccupied: true, startDate: Date().addingTimeInterval(-86400 * Double.random(in: 1...30))),
        ParkingSpot(coordinate: CLLocationCoordinate2D(latitude: 40.9922, longitude: 29.1243), name: "Bostancı Sahil Otoparkı", isOccupied: false, startDate: nil),
        ParkingSpot(coordinate: CLLocationCoordinate2D(latitude: 41.0565, longitude: 28.9876), name: "Levent Kanyon AVM Yanı", isOccupied: false, startDate: nil),
        ParkingSpot(coordinate: CLLocationCoordinate2D(latitude: 41.0088, longitude: 29.0402), name: "Fenerbahçe Parkı Otoparkı", isOccupied: false, startDate: nil),
        ParkingSpot(coordinate: CLLocationCoordinate2D(latitude: 41.0455, longitude: 28.9324), name: "Ortaköy Meydanı Otoparkı", isOccupied: false, startDate: nil),
        ParkingSpot(coordinate: CLLocationCoordinate2D(latitude: 41.0280, longitude: 29.1168), name: "Maltepe Sahil Parkı", isOccupied: true, startDate: Date().addingTimeInterval(-86400 * Double.random(in: 1...30))),
        ParkingSpot(coordinate: CLLocationCoordinate2D(latitude: 40.9794, longitude: 28.8856), name: "Florya Sahil Parkı", isOccupied: false, startDate: nil),
        ParkingSpot(coordinate: CLLocationCoordinate2D(latitude: 41.0698, longitude: 28.8056), name: "Yeşilköy Marina Parkı", isOccupied: false, startDate: nil),
        ParkingSpot(coordinate: CLLocationCoordinate2D(latitude: 41.0110, longitude: 28.9834),name: "Maslak İş Merkezleri Otoparkı", isOccupied: true, startDate: Date().addingTimeInterval(-86400 * Double.random(in: 1...30))),
        ParkingSpot(coordinate: CLLocationCoordinate2D(latitude: 41.0439, longitude: 29.0079), name: "Ataşehir Bulvar Parkı",isOccupied: false,  startDate: nil),
        ParkingSpot(coordinate: CLLocationCoordinate2D(latitude: 41.0077, longitude: 28.9786), name: "Bakırköy Botanik Park Otoparkı", isOccupied: true, startDate: Date().addingTimeInterval(-86400 * Double.random(in: 1...30)))
    ]



    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: parkingSpots) { spot in
                MapAnnotation(coordinate: spot.coordinate) {
                    Button(action: {
                        selectedSpot = spot
                        getAddress(from: spot.coordinate)
                    }) {
                        VStack {
                            Text(spot.isOccupied ? "Occupied" : "Empty")
                                .foregroundColor(.white)
                                .padding(5)
                                .background(spot.isOccupied ? Color.red : Color.green)
                                .cornerRadius(5)
                            Image(systemName: "qrcode.viewfinder")
                                .foregroundColor(.white)
                                .padding(5)
                                .background(Color.blue)
                                .cornerRadius(5)
                        }
                    }
                }
            }
            .ignoresSafeArea()
            .alert(isPresented: $showingDetails) {
                guard let spot = selectedSpot else {
                    return Alert(
                        title: Text("Error"),
                        message: Text("No parking spot selected."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                let parkingDetails = calculateParkingDetails(spot: spot)
                return Alert(
                    title: Text("Parking Spot Information"),
                    message: Text("Name: \(spot.name)\nAddress: \(address)\nDuration: \(parkingDetails.duration)\nCost: \(parkingDetails.cost)"),
                    dismissButton: .default(Text("OK"))
                )
            }


            Button("Scan QR Code") {
                showingScanner = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.bottom, 20)
        }
        .sheet(isPresented: $showingScanner) {
            QRCodeScannerView(scannedCode: $scannedCode)
        }.onChange(of: scannedCode) { newValue in
            processScannedCode()
        }.sheet(isPresented: $showingPayment) {
            if let startDate = currentStartDate {
                PaymentView(startDate: startDate, pricePerHour: currentPricePerHour)
            } else {
                Text("Error: No start date available.")
            }
        }


    }

    func getAddress(from coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error in reverseGeocode: \(error)")
                return
            }
            if let placemark = placemarks?.first {
                self.address = [
                    placemark.thoroughfare,
                    placemark.locality,
                    placemark.administrativeArea,
                    placemark.postalCode,
                    placemark.country
                ].compactMap { $0 }.joined(separator: ", ")
                self.showingDetails = true // Ensure to set this true here after updating address
            }
        }
    }

    func processScannedCode() {
        guard let code = scannedCode, !code.isEmpty else { return }
        if let index = parkingSpots.firstIndex(where: { $0.name == code }) {
            var spot = parkingSpots[index]
            if spot.isOccupied {
                // Occupied to empty
                parkingSpots[index].isOccupied.toggle()
                currentStartDate = parkingSpots[index].startDate // save startDate
                currentPricePerHour = parkingSpots[index].pricePerHour // save pricePerHour
                parkingSpots[index].startDate = nil // reset startDate
                showingPayment = true
            } else {
                // Empty to Ocuppied
                parkingSpots[index].isOccupied.toggle()
                parkingSpots[index].startDate = Date() // Yeni startDate ayarla

            }
        }
    }
    func calculateParkingDetails(spot: ParkingSpot) -> (duration: String, cost: String) {
        guard let startDate = spot.startDate else {
            return ("Not available", "Not available")
        }
        let endDate = Date()
        let parkedDuration = Calendar.current.dateComponents([.minute], from: startDate, to: endDate)
        let hoursParked = Double(parkedDuration.minute ?? 0) / 60
        let totalPrice = hoursParked * spot.pricePerHour

        let formattedDuration = String(format: "%.2f hours", hoursParked)
        let formattedCost = String(format: "%.2fTL", totalPrice)
        return (formattedDuration, formattedCost)
    }
    


}

#Preview {
    ContentView()
}
