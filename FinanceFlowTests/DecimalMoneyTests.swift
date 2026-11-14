//
//  DecimalMoneyTests.swift
//  FinanceFlowTests
//

import Foundation
import Testing
@testable import FinanceFlow

struct DecimalMoneyTests {

    @Test(arguments: [
        ("149,99", "149.99"),
        ("149.99", "149.99"),
        ("149", "149"),
    ])
    func validUserInputParses(input: String, expected: String) {
        let expectedValue = Decimal(string: expected)!
        #expect(Decimal(userInput: input) == expectedValue)
    }

    @Test(arguments: ["1.234,56", "149,999", "abc", ""])
    func invalidUserInputReturnsNil(input: String) {
        #expect(Decimal(userInput: input) == nil)
    }

    @Test
    func roundedToIntHandlesRepeatingDecimal() {
        // (200 + 15) / 30000 = 0.00716666... (repeating) — this is the exact
        // ratio that exposed the NSDecimalNumber(...).intValue bug.
        let harcamaOrani = (Decimal(200) + Decimal(15)) / Decimal(30000)
        let value = (1 - harcamaOrani) * 100
        #expect(value.roundedToInt() == 99)
    }

    @Test
    func roundedToIntRoundsExactHalfAwayFromZero() {
        // NSDecimalRound with .plain rounds ties away from zero: 2.5 -> 3, not 2.
        #expect(Decimal(2.5).roundedToInt() == 3)
    }
}
