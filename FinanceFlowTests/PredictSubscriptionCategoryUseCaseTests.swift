//
//  PredictSubscriptionCategoryUseCaseTests.swift
//  FinanceFlowTests
//

import Foundation
import Testing
@testable import FinanceFlow

struct PredictSubscriptionCategoryUseCaseTests {

    @Test(arguments: [
        ("Netflix", SubscriptionCategory.eglence),
        ("Spotify", SubscriptionCategory.muzik),
        ("Steam", SubscriptionCategory.oyun),
        ("Notion", SubscriptionCategory.uretkenlik),
        ("Gym", SubscriptionCategory.saglik),
        ("RandomXyz", SubscriptionCategory.diger),
        ("netflix", SubscriptionCategory.eglence),
        ("NETFLIX", SubscriptionCategory.eglence),
        ("Netflix Premium", SubscriptionCategory.eglence),
        ("", SubscriptionCategory.diger),
    ])
    func predictsCorrectCategory(name: String, expected: SubscriptionCategory) {
        let useCase = PredictSubscriptionCategoryUseCase()
        #expect(useCase.execute(name: name) == expected)
    }
}
