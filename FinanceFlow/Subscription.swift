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
    var price: Double
    var paymentDate: Date
    var category: SubscriptionCategory = .diger
    
    
    static func kategoriTahmin(isim: String) -> SubscriptionCategory {
        let isim = isim.lowercased()
        
        let muzikKeywords = ["spotify", "music", "müzik", "podcast", "tidal", "deezer", "soundcloud"]
        let eglenceKeywords = ["netflix", "disney", "exxen", "youtube", "prime", "hulu", "tv", "film", "dizi", "blutv", "gain"]
        let oyunKeywords = ["steam", "xbox", "playstation", "gaming", "oyun", "epic", "nintendo"]
        let uretkenlikKeywords = ["notion", "figma", "adobe", "office", "microsoft", "slack", "zoom", "dropbox", "icloud"]
        let saglikKeywords = ["gym", "spor", "sağlık", "health", "fitness", "yoga", "meditasyon"]
        
        if muzikKeywords.contains(where: { isim.contains($0) }) { return .muzik }
        if eglenceKeywords.contains(where: { isim.contains($0) }) { return .eglence }
        if oyunKeywords.contains(where: { isim.contains($0) }) { return .oyun }
        if uretkenlikKeywords.contains(where: { isim.contains($0) }) { return .uretkenlik }
        if saglikKeywords.contains(where: { isim.contains($0) }) { return .saglik }
        return .diger
    }
}
