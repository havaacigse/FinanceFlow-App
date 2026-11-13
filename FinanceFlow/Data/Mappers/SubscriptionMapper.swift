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
        guard let price = data["price"] as? Double else {
            throw SubscriptionMapperError.missingField("price")
        }
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
            "price": subscription.price,
            "paymentDate": Timestamp(date: subscription.paymentDate),
            "category": subscription.category.rawValue
        ]
    }
}
