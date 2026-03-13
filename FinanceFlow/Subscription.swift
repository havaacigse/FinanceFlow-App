//
//  Subscription.swift
//  FinanceFlow
//
//  Created by HAVVA on 4.03.2026.
//

import Foundation

struct Subscription: Identifiable {
    var id = UUID()
    var name: String
    var price: Double
    var paymentDate: Date
}
