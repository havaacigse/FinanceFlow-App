import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {
    private(set) var subscriptions: [Subscription] = []
    private(set) var isLoading = false
    private(set) var reloadID = UUID()
    var listErrorMessage: String?
    var actionErrorMessage: String?

    var totalMonthly: Decimal {
        subscriptions.reduce(0) { $0 + $1.price }
    }

    private let repository: SubscriptionRepositoryProtocol
    private let notificationScheduler: SubscriptionNotificationScheduling

    init(
        repository: SubscriptionRepositoryProtocol = FirebaseSubscriptionRepository(),
        notificationScheduler: SubscriptionNotificationScheduling = SubscriptionNotificationScheduler()
    ) {
        self.repository = repository
        self.notificationScheduler = notificationScheduler
    }

    func retry() {
        reloadID = UUID()
    }

    func start() async {
        isLoading = true
        listErrorMessage = nil
        do {
            for try await subscriptions in repository.observeSubscriptions() {
                self.subscriptions = subscriptions
                self.isLoading = false
            }
        } catch {
            isLoading = false
            listErrorMessage = error.localizedDescription
        }
    }

    func save(_ subscription: Subscription) async {
        do {
            try await repository.save(subscription)
            notificationScheduler.scheduleNotification(for: subscription)
        } catch {
            actionErrorMessage = error.localizedDescription
        }
    }

    func delete(_ subscription: Subscription) async {
        do {
            try await repository.delete(id: subscription.id)
            notificationScheduler.cancelNotification(for: subscription.id)
        } catch {
            actionErrorMessage = error.localizedDescription
        }
    }
}
