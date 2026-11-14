import Foundation
@testable import FinanceFlow

final class MockSubscriptionRepository: SubscriptionRepositoryProtocol {
    var subscriptionBatches: [[Subscription]] = []
    var streamError: Error?
    var saveError: Error?
    var deleteError: Error?

    private(set) var savedSubscriptions: [Subscription] = []
    private(set) var deletedIDs: [UUID] = []

    func observeSubscriptions() -> AsyncThrowingStream<[Subscription], Error> {
        AsyncThrowingStream { continuation in
            for batch in subscriptionBatches {
                continuation.yield(batch)
            }
            if let streamError {
                continuation.finish(throwing: streamError)
            } else {
                continuation.finish()
            }
        }
    }

    func save(_ subscription: Subscription) async throws {
        if let saveError {
            throw saveError
        }
        savedSubscriptions.append(subscription)
    }

    func delete(id: UUID) async throws {
        if let deleteError {
            throw deleteError
        }
        deletedIDs.append(id)
    }
}
