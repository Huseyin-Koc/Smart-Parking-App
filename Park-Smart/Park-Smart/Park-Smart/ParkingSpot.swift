//
//  ParkingSpot.swift
//  Park-Smart
//
//  Created by Hüseyin Koç on 7.05.2024.
//

import SwiftUI
import MapKit
import CoreLocation

// Model for each parking spot
struct ParkingSpot: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    var name: String
    var isOccupied: Bool
    var vehicleType: String?
    var parkedTime: Date?
    var pricePerHour: Double = 2.34  // Default price per hour
    var startDate: Date?  // Start date when the spot becomes occupied
}


