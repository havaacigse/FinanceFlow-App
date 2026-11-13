import Foundation
import Observation

@MainActor
@Observable
final class AddSubscriptionViewModel {
    var name = ""
    var priceText = ""
    var paymentDate = Date()
    var category: SubscriptionCategory = .diger

    private let predictCategory = PredictSubscriptionCategoryUseCase()
    private var isCategoryManuallySet = false

    var nameErrorMessage: String? {
        guard !name.isEmpty else { return nil }
        return name.trimmingCharacters(in: .whitespaces).isEmpty ? "Abonelik adı boş olamaz" : nil
    }

    var priceErrorMessage: String? {
        guard !priceText.isEmpty else { return nil }
        guard let price = parsedPrice else { return "Geçerli bir fiyat girin" }
        return price > 0 ? nil : "Fiyat 0'dan büyük olmalı"
    }

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && (parsedPrice ?? 0) > 0
    }

    private var parsedPrice: Double? {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        return formatter.number(from: priceText)?.doubleValue
    }

    func predictCategoryFromName() {
        guard !isCategoryManuallySet else { return }
        category = predictCategory.execute(name: name)
    }

    func setCategory(_ newValue: SubscriptionCategory) {
        category = newValue
        isCategoryManuallySet = true
    }

    func makeSubscription() -> Subscription? {
        guard isValid, let price = parsedPrice else { return nil }
        return Subscription(
            name: name.trimmingCharacters(in: .whitespaces),
            price: price,
            paymentDate: paymentDate,
            category: category
        )
    }
}
