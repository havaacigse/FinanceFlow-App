//
//  MLServiceTests.swift
//  FinanceFlowTests
//

import Foundation
import Testing
@testable import FinanceFlow

struct MLServiceTests {

    @Test
    func realWorldBugRegression_skorIsNinetyNine() {
        let service = MLService()
        let result = service.finansalSaglikSkoru(gelir: 30000, abonelik: 200, gecenAyHarcama: 15)
        #expect(result.skor == 99)
    }

    @Test
    func zeroIncomeReturnsHesaplanamadi() {
        let service = MLService()
        let result = service.finansalSaglikSkoru(gelir: 0, abonelik: 200, gecenAyHarcama: 15)
        #expect(result.skor == 0)
        #expect(result.durum == "Hesaplanamadı")
    }

    @Test
    func zeroIncomeRiskIsHesaplanamadi() {
        let service = MLService()
        let risk = service.iflasRiski(gelir: 0, abonelik: 200, gecenAyHarcama: 15)
        #expect(risk.durum == .hesaplanamadi)
        #expect(risk.oran == nil)
    }

    @Test
    func boundarySkorExactlyForty_isNotRiskli() {
        let service = MLService()
        let saglik = service.finansalSaglikSkoru(gelir: 100, abonelik: 0, gecenAyHarcama: 60)
        let risk = service.iflasRiski(gelir: 100, abonelik: 0, gecenAyHarcama: 60)
        #expect(saglik.skor == 40)
        #expect(saglik.durum == "Dikkatli")
        #expect(risk.durum == .guvenli)
    }

    @Test
    func boundarySkorExactlyThirtyNine_isRiskli() {
        let service = MLService()
        let saglik = service.finansalSaglikSkoru(gelir: 100, abonelik: 0, gecenAyHarcama: 61)
        let risk = service.iflasRiski(gelir: 100, abonelik: 0, gecenAyHarcama: 61)
        #expect(saglik.skor == 39)
        #expect(saglik.durum == "Tehlikeli")
        #expect(risk.durum == .riskli)
    }

    @Test(arguments: [
        (Decimal(100), Decimal(0), Decimal(10)),
        (Decimal(100), Decimal(0), Decimal(50)),
        (Decimal(100), Decimal(0), Decimal(80)),
        (Decimal(0), Decimal(0), Decimal(10)),
        (Decimal(30000), Decimal(200), Decimal(15)),
    ])
    func skorAndRiskAreAlwaysConsistent(gelir: Decimal, abonelik: Decimal, gecenAyHarcama: Decimal) {
        let service = MLService()
        let saglik = service.finansalSaglikSkoru(gelir: gelir, abonelik: abonelik, gecenAyHarcama: gecenAyHarcama)
        let risk = service.iflasRiski(gelir: gelir, abonelik: abonelik, gecenAyHarcama: gecenAyHarcama)
        if saglik.durum == "Hesaplanamadı" {
            #expect(risk.durum == .hesaplanamadi)
        } else {
            #expect(risk.durum == (saglik.skor < 40 ? .riskli : .guvenli))
        }
    }
}
