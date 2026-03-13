//
//  FinanceFlowApp.swift

//  FinanceFlow
//
//  Created by HAVVA on 4.03.2026.
//


import SwiftUI
import Firebase
import UserNotifications

@main
struct FinanceFlowApp: App {
    
    init(){
        FirebaseApp.configure()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
