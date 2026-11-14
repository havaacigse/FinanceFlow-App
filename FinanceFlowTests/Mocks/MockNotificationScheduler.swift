import Foundation
@testable import FinanceFlow

final class MockNotificationScheduler: SubscriptionNotificationScheduling {
    private(set) var scheduledSubscriptions: [Subscription] = []
    private(set) var canceledIDs: [UUID] = []

    func scheduleNotification(for subscription: Subscription) {
        scheduledSubscriptions.append(subscription)
    }

    func cancelNotification(for subscriptionID: UUID) {
        canceledIDs.append(subscriptionID)
    }
}
