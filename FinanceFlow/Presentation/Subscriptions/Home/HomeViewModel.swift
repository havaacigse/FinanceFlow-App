import Foundation
import Observation
import UserNotifications

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

    init(repository: SubscriptionRepositoryProtocol = FirebaseSubscriptionRepository()) {
        self.repository = repository
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
            scheduleNotification(for: subscription)
        } catch {
            actionErrorMessage = error.localizedDescription
        }
    }

    func delete(_ subscription: Subscription) async {
        do {
            try await repository.delete(id: subscription.id)
        } catch {
            actionErrorMessage = error.localizedDescription
        }
    }

    private func scheduleNotification(for subscription: Subscription) {
        let content = UNMutableNotificationContent()
        content.title = "Ödeme Zamanı! 💳"
        content.body = "\(subscription.name) aboneliğin bugün yenileniyor: \(subscription.price.formattedAsCurrency())"
        content.sound = .default

        var dateComponents = Calendar.current.dateComponents([.month, .day], from: subscription.paymentDate)
        dateComponents.hour = 9

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: subscription.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
}
