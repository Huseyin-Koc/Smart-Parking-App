//
//  Item.swift
//  Park-Smart
//
//  Created by Hüseyin Koç on 4.05.2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
