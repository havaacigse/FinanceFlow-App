import Foundation

struct PredictSubscriptionCategoryUseCase {
    func execute(name: String) -> SubscriptionCategory {
        let name = name.lowercased()

        let muzikKeywords = ["spotify", "music", "müzik", "podcast", "tidal", "deezer", "soundcloud"]
        let eglenceKeywords = ["netflix", "disney", "exxen", "youtube", "prime", "hulu", "tv", "film", "dizi", "blutv", "gain"]
        let oyunKeywords = ["steam", "xbox", "playstation", "gaming", "oyun", "epic", "nintendo"]
        let uretkenlikKeywords = ["notion", "figma", "adobe", "office", "microsoft", "slack", "zoom", "dropbox", "icloud"]
        let saglikKeywords = ["gym", "spor", "sağlık", "health", "fitness", "yoga", "meditasyon"]

        if muzikKeywords.contains(where: { name.contains($0) }) { return .muzik }
        if eglenceKeywords.contains(where: { name.contains($0) }) { return .eglence }
        if oyunKeywords.contains(where: { name.contains($0) }) { return .oyun }
        if uretkenlikKeywords.contains(where: { name.contains($0) }) { return .uretkenlik }
        if saglikKeywords.contains(where: { name.contains($0) }) { return .saglik }
        return .diger
    }
}
