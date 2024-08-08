/*import SwiftUI
import Firebase

struct ContentView: View {
    @State private var parkingSpots = [ParkingSpot]()

    var body: some View {
        List(parkingSpots, id: \.id) { spot in
            Text(spot.name)
        }
        .onAppear {
            fetchParkingSpots()
        }
    }

    private func fetchParkingSpots() {
        let db = Firestore.firestore()
        db.collection("parkingSpots").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    let data = document.data()
                    let name = data["name"] as? String ?? "Unknown"
                    let id = document.documentID
                    let newSpot = ParkingSpot(id: id, name: name)
                    parkingSpots.append(newSpot)
                }
            }
        }
    }
}

struct ParkingSpot {
    var id: String
    var name: String
}*/
