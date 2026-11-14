import Foundation
import UserNotifications

struct SubscriptionNotificationScheduler: SubscriptionNotificationScheduling {
    func scheduleNotification(for subscription: Subscription) {
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

    func cancelNotification(for subscriptionID: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [subscriptionID.uuidString])
    }
}
