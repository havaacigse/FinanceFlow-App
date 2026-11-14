import Foundation
import Observation

@MainActor
@Observable
final class SubscriptionFormViewModel {
    enum Mode {
        case new
        case edit(Subscription)
    }

    var name: String
    var priceText: String
    var paymentDate: Date
    var category: SubscriptionCategory

    private let id: UUID
    private let predictCategory = PredictSubscriptionCategoryUseCase()
    private var isCategoryManuallySet: Bool

    init(mode: Mode) {
        switch mode {
        case .new:
            id = UUID()
            name = ""
            priceText = ""
            paymentDate = Date()
            category = .diger
            isCategoryManuallySet = false
        case .edit(let subscription):
            id = subscription.id
            name = subscription.name
            priceText = Self.format(subscription.price)
            paymentDate = subscription.paymentDate
            category = subscription.category
            isCategoryManuallySet = true
        }
    }

    var nameErrorMessage: String? {
        guard !name.isEmpty else { return nil }
        return name.trimmingCharacters(in: .whitespaces).isEmpty ? "Abonelik adı boş olamaz" : nil
    }

    var priceErrorMessage: String? {
        guard !priceText.isEmpty else { return nil }
        guard let price = parsedPrice else {
            let separator = Locale.current.decimalSeparator ?? ","
            return "Geçerli bir fiyat girin (örn. 149\(separator)99)"
        }
        return price > 0 ? nil : "Fiyat 0'dan büyük olmalı"
    }

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && (parsedPrice ?? 0) > 0
    }

    private var parsedPrice: Decimal? {
        Decimal(userInput: priceText)
    }

    private static let displayFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    private static func format(_ price: Decimal) -> String {
        displayFormatter.string(from: NSDecimalNumber(decimal: price)) ?? "\(price)"
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
            id: id,
            name: name.trimmingCharacters(in: .whitespaces),
            price: price,
            paymentDate: paymentDate,
            category: category
        )
    }
}
