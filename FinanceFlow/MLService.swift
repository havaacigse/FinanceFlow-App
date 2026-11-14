//
//  MLService.swift
//  FinanceFlow
//
//  Created by HAVVA on 8.03.2026.
//

import Foundation
import CoreML

struct MLService {

    private let model: BurnRateModel? = try? BurnRateModel(configuration: MLModelConfiguration())

    func kalanBakiyeTahmini(gelir: Decimal, abonelik: Decimal, gecenAyHarcama: Decimal) -> Decimal {
        let input = BurnRateModelInput(
            gelir: Self.asDouble(gelir),
            abonelik: Self.asDouble(abonelik),
            gecen_ay_harcama: Self.asDouble(gecenAyHarcama)
        )
        guard let output = try? model?.prediction(input: input) else { return 0 }
        return max(0, Decimal(output.kalan_bakiye))
    }

      func finansalSaglikSkoru(gelir: Decimal, abonelik: Decimal, gecenAyHarcama: Decimal) -> (skor: Int, durum: String, renk: String) {
        let harcamaOrani = (abonelik + gecenAyHarcama) / gelir
        let skor = max(0, min(100, NSDecimalNumber(decimal: (1 - harcamaOrani) * 100).intValue))
        if skor >= 70 { return (skor, "Sağlıklı", "green") }
        else if skor >= 40 { return (skor, "Dikkatli", "yellow") }
        else { return (skor, "Tehlikeli", "red") }
    }

    func kacGundeBiter(abonelik: Decimal, gecenAyHarcama: Decimal, mevcutBakiye: Decimal) -> (gun: Int, tarih: String) {
        let gunlukHarcama = (abonelik + gecenAyHarcama) / 30
        guard gunlukHarcama > 0 else { return (0, "Hesaplanamadı") }
        let kalanGun = NSDecimalNumber(decimal: mevcutBakiye / gunlukHarcama).intValue
        let tarih = Calendar.current.date(byAdding: .day, value: kalanGun, to: Date()) ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "tr_TR")
        return (kalanGun, formatter.string(from: tarih))
    }

    func iflasRiski(gelir: Decimal, abonelik: Decimal, gecenAyHarcama: Decimal) -> (riskli: Bool, oran: Decimal) {
        let harcamaOrani = (abonelik + gecenAyHarcama) / gelir
        return (harcamaOrani > 0.7, min(harcamaOrani * 100, 100))
    }

    private static func asDouble(_ value: Decimal) -> Double {
        NSDecimalNumber(decimal: value).doubleValue
    }
}
