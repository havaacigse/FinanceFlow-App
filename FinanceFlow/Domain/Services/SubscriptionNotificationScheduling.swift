import Foundation

protocol SubscriptionNotificationScheduling {
    func scheduleNotification(for subscription: Subscription)
    func cancelNotification(for subscriptionID: UUID)
}
