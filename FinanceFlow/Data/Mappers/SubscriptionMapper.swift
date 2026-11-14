import Foundation
import FirebaseFirestore

enum SubscriptionMapperError: Error {
    case missingField(String)
}

struct SubscriptionMapper {
    func toDomain(documentID: String, data: [String: Any]) throws -> Subscription {
        guard let name = data["name"] as? String else {
            throw SubscriptionMapperError.missingField("name")
        }
        let price = try Self.readPrice(from: data)
        guard let timestamp = data["paymentDate"] as? Timestamp else {
            throw SubscriptionMapperError.missingField("paymentDate")
        }
        let category = SubscriptionCategory(rawValue: data["category"] as? String ?? "") ?? .diger

        return Subscription(
            id: UUID(uuidString: documentID) ?? UUID(),
            name: name,
            price: price,
            paymentDate: timestamp.dateValue(),
            category: category
        )
    }

    func toFirestoreData(_ subscription: Subscription) -> [String: Any] {
        [
            "name": subscription.name,
            "priceMinor": Self.minorUnits(from: subscription.price),
            "paymentDate": Timestamp(date: subscription.paymentDate),
            "category": subscription.category.rawValue
        ]
    }

    private static func readPrice(from data: [String: Any]) throws -> Decimal {
        if let minorUnits = data["priceMinor"] as? Int {
            return Decimal(minorUnits) / 100
        }
        if let legacyDouble = data["price"] as? Double {
            let minorUnits = Int((legacyDouble * 100).rounded())
            return Decimal(minorUnits) / 100
        }
        throw SubscriptionMapperError.missingField("price")
    }

    private static func minorUnits(from price: Decimal) -> Int {
        (price * 100).roundedToInt()
    }
}
