import Foundation

protocol SubscriptionRepositoryProtocol {
    func observeSubscriptions() -> AsyncThrowingStream<[Subscription], Error>
    func save(_ subscription: Subscription) async throws
    func delete(id: String) async throws
}
