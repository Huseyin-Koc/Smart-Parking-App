//
//  Park_SmartApp.swift
//  Park-Smart
//
//  Created by Hüseyin Koç on 4.05.2024.
//
import SwiftUI
import SwiftData

@main
struct Park_SmartApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,  // Ensure that Item is defined elsewhere in your project
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            LogInView()  // Changed from ContentView to LogInView
        }
        .modelContainer(sharedModelContainer)
    }
}
