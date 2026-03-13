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
    
    func kalanBakiyeTahmini(gelir: Double, abonelik: Double, gecenAyHarcama: Double) -> Double {
        let input = BurnRateModelInput(gelir: gelir, abonelik: abonelik, gecen_ay_harcama: gecenAyHarcama)
        guard let output = try? model?.prediction(input: input) else { return 0 }
        return max(0, output.kalan_bakiye)
    }
    
    func finansalSaglikSkoru(gelir: Double, abonelik: Double, gecenAyHarcama: Double) -> (skor: Int, durum: String, renk: String) {
        let harcamaOrani = (abonelik + gecenAyHarcama) / gelir
        if harcamaOrani < 0.5 { return (100, "Sağlıklı", "green") }
        else if harcamaOrani < 0.7 { return (60, "Dikkatli", "yellow") }
        else { return (20, "Tehlikeli", "red") }
    }
    
    func kacGundeBiter(abonelik: Double, gecenAyHarcama: Double, mevcutBakiye: Double) -> (gun: Int, tarih: String) {
        let gunlukHarcama = (abonelik + gecenAyHarcama) / 30
        guard gunlukHarcama > 0 else { return (0, "Hesaplanamadı") }
        let kalanGun = Int(mevcutBakiye / gunlukHarcama)
        let tarih = Calendar.current.date(byAdding: .day, value: kalanGun, to: Date()) ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "tr_TR")
        return (kalanGun, formatter.string(from: tarih))
    }
    
    func iflasRiski(gelir: Double, abonelik: Double, gecenAyHarcama: Double) -> (riskli: Bool, oran: Double) {
        let harcamaOrani = (abonelik + gecenAyHarcama) / gelir
        return (harcamaOrani > 0.7, min(harcamaOrani * 100, 100))
    }
}
