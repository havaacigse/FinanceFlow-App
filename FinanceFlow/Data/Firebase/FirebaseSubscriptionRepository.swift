import Foundation
import FirebaseFirestore
import FirebaseAuth

enum SubscriptionRepositoryError: Error {
    case notAuthenticated
}

struct FirebaseSubscriptionRepository: SubscriptionRepositoryProtocol {
    private enum Path {
        static let users = "users"
        static let subscriptions = "subscriptions"
    }

    private let db = Firestore.firestore()
    private let mapper = SubscriptionMapper()

    func observeSubscriptions() -> AsyncThrowingStream<[Subscription], Error> {
        AsyncThrowingStream { continuation in
            guard let uid = Auth.auth().currentUser?.uid else {
                continuation.finish(throwing: SubscriptionRepositoryError.notAuthenticated)
                return
            }

            let listener = db.collection(Path.users).document(uid)
                .collection(Path.subscriptions)
                .addSnapshotListener { snapshot, error in
                    if let error = error {
                        continuation.finish(throwing: error)
                        return
                    }
                    guard let documents = snapshot?.documents else { return }

                    let subscriptions = documents.compactMap { document -> Subscription? in
                        do {
                            return try mapper.toDomain(documentID: document.documentID, data: document.data())
                        } catch {
                            print("SubscriptionMapper failed for document \(document.documentID): \(error)")
                            return nil
                        }
                    }
                    continuation.yield(subscriptions)
                }

            continuation.onTermination = { _ in
                listener.remove()
            }
        }
    }

    func save(_ subscription: Subscription) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw SubscriptionRepositoryError.notAuthenticated
        }
        try await db.collection(Path.users).document(uid)
            .collection(Path.subscriptions)
            .document(subscription.id.uuidString)
            .setData(mapper.toFirestoreData(subscription))
    }

    func delete(id: UUID) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw SubscriptionRepositoryError.notAuthenticated
        }
        try await db.collection(Path.users).document(uid)
            .collection(Path.subscriptions)
            .document(id.uuidString)
            .delete()
    }
}
