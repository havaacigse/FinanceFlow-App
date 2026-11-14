//
//  Subscription.swift
//  FinanceFlow
//
//  Created by HAVVA on 4.03.2026.
//

import Foundation

enum SubscriptionCategory: String, CaseIterable {
    case eglence = "Eğlence"
    case muzik = "Müzik"
    case oyun = "Oyun"
    case uretkenlik = "Üretkenlik"
    case saglik = "Sağlık"
    case diger = "Diğer"
}

struct Subscription: Identifiable {
    var id = UUID()
    var name: String
    var price: Decimal
    var paymentDate: Date
    var category: SubscriptionCategory = .diger
}
