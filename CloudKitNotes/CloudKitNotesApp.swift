//
//  CloudKitNotesApp.swift
//  CloudKitNotes
//
//  Created by ec2-user on 24/03/2025.
//

import SwiftUI

@main
struct CloudKitNotesApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
}
