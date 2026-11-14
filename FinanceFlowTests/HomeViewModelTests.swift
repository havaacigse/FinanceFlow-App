//
//  HomeViewModelTests.swift
//  FinanceFlowTests
//

import Foundation
import Testing
@testable import FinanceFlow

private struct SampleError: Error {}

@MainActor
struct HomeViewModelTests {

    @Test
    func startUpdatesSubscriptionsFromStream() async {
        let repository = MockSubscriptionRepository()
        let sample = Subscription(name: "Netflix", price: 149.99, paymentDate: Date())
        repository.subscriptionBatches = [[sample]]
        let viewModel = HomeViewModel(repository: repository, notificationScheduler: MockNotificationScheduler())

        await viewModel.start()

        #expect(viewModel.subscriptions.count == 1)
        #expect(viewModel.subscriptions.first?.name == "Netflix")
        #expect(viewModel.isLoading == false)
    }

    @Test
    func startSetsListErrorMessageOnStreamFailure() async {
        let repository = MockSubscriptionRepository()
        repository.streamError = SampleError()
        let viewModel = HomeViewModel(repository: repository, notificationScheduler: MockNotificationScheduler())

        await viewModel.start()

        #expect(viewModel.listErrorMessage != nil)
        #expect(viewModel.isLoading == false)
    }

    @Test
    func retryChangesReloadID() {
        let viewModel = HomeViewModel(repository: MockSubscriptionRepository(), notificationScheduler: MockNotificationScheduler())
        let initialID = viewModel.reloadID

        viewModel.retry()

        #expect(viewModel.reloadID != initialID)
    }

    @Test
    func saveSuccessCallsRepositoryAndSchedulesNotification() async {
        let repository = MockSubscriptionRepository()
        let scheduler = MockNotificationScheduler()
        let viewModel = HomeViewModel(repository: repository, notificationScheduler: scheduler)
        let sample = Subscription(name: "Netflix", price: 149.99, paymentDate: Date())

        await viewModel.save(sample)

        #expect(repository.savedSubscriptions.count == 1)
        #expect(scheduler.scheduledSubscriptions.count == 1)
        #expect(viewModel.actionErrorMessage == nil)
    }

    @Test
    func saveFailureSetsActionErrorMessageAndSkipsNotification() async {
        let repository = MockSubscriptionRepository()
        repository.saveError = SampleError()
        let scheduler = MockNotificationScheduler()
        let viewModel = HomeViewModel(repository: repository, notificationScheduler: scheduler)
        let sample = Subscription(name: "Netflix", price: 149.99, paymentDate: Date())

        await viewModel.save(sample)

        #expect(viewModel.actionErrorMessage != nil)
        #expect(scheduler.scheduledSubscriptions.isEmpty)
    }

    @Test
    func deleteFailureSetsActionErrorMessage() async {
        let repository = MockSubscriptionRepository()
        repository.deleteError = SampleError()
        let scheduler = MockNotificationScheduler()
        let viewModel = HomeViewModel(repository: repository, notificationScheduler: scheduler)
        let sample = Subscription(name: "Netflix", price: 149.99, paymentDate: Date())

        await viewModel.delete(sample)

        #expect(viewModel.actionErrorMessage != nil)
        #expect(scheduler.canceledIDs.isEmpty)
    }

    @Test
    func deleteSuccessCancelsNotification() async {
        let repository = MockSubscriptionRepository()
        let scheduler = MockNotificationScheduler()
        let viewModel = HomeViewModel(repository: repository, notificationScheduler: scheduler)
        let sample = Subscription(name: "Netflix", price: 149.99, paymentDate: Date())

        await viewModel.delete(sample)

        #expect(repository.deletedIDs == [sample.id])
        #expect(scheduler.canceledIDs == [sample.id])
    }
}
