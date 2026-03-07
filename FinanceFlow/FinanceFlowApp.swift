//
//  FinanceFlowApp.swift

//  FinanceFlow
//
//  Created by HAVVA on 4.03.2026.
//


import SwiftUI
import Firebase

@main
struct FinanceFlowApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
