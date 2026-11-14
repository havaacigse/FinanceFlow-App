import Foundation
@testable import FinanceFlow

final class MockNotificationScheduler: SubscriptionNotificationScheduling {
    private(set) var scheduledSubscriptions: [Subscription] = []

    func scheduleNotification(for subscription: Subscription) {
        scheduledSubscriptions.append(subscription)
    }
}
