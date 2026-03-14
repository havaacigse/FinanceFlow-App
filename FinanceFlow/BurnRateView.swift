//
//  BurnRateView.swift
//  FinanceFlow
//
//  Created by HAVVA on 5.03.2026.
//

import SwiftUI
import Charts

struct BurnRateView: View {
    @State private var gelir = ""
    @State private var gecenAyHarcama = ""
    @State private var mevcutBakiye = ""
    @State private var analizYapildi = false
    @Environment(\.dismiss) var dismiss
    
    let ml = MLService()
    let subs: [Subscription]
    
    var toplamAbonelik: Double {
        subs.reduce(0) { $0 + $1.price }
    }
    
    var g: Double { Double(gelir) ?? 0 }
    var h: Double { Double(gecenAyHarcama) ?? 0 }
    
    var kalan: Double { ml.kalanBakiyeTahmini(gelir: g, abonelik: toplamAbonelik, gecenAyHarcama: h) }
    var saglik: (skor: Int, durum: String, renk: String) { ml.finansalSaglikSkoru(gelir: g, abonelik: toplamAbonelik, gecenAyHarcama: h) }
    var risk: (riskli: Bool, oran: Double) { ml.iflasRiski(gelir: g, abonelik: toplamAbonelik, gecenAyHarcama: h) }
    
    var grafikVerisi: [(ay: String, deger: Double)] {
        let aylar = ["Oca", "Şub", "Mar", "Nis", "May", "Haz"]
        return aylar.enumerated().map { i, ay in
            let tahmini = kalan - (Double(i) * (toplamAbonelik + h * 0.15))
            return (ay, max(0, tahmini))
        }
    }
    
    var kategoriHarcama: [(kategori: String, deger: Double)] {
        Dictionary(grouping: subs, by: { $0.category.rawValue })
            .map { (kategori: $0.key, deger: $0.value.reduce(0) { $0 + $1.price }) }
            .sorted(by: { $0.deger > $1.deger })
    }
    
    var skorRenk: Color {
        guard analizYapildi else { return .gray }
        switch saglik.skor {
        case 80...100: return .green
        case 40...79: return .yellow
        default: return .red
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text("Finansal Analiz")
                        .font(.largeTitle).bold()
                    Spacer()
                }
                .padding(.horizontal)
                
                VStack(spacing: 12) {
                    TextField("Aylık Geliriniz (₺)", text: $gelir)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    
                    TextField("Geçen Ay Harcama (₺)", text: $gecenAyHarcama)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Button("Analiz Et") {
                    guard !gelir.isEmpty, !gecenAyHarcama.isEmpty else { return }
                    withAnimation { analizYapildi = true }
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
                .padding(.horizontal)
                
                if analizYapildi {
                    VStack(spacing: 8) {
                        Text("Finansal Sağlık Skoru")
                            .font(.headline)
                        Text("\(saglik.skor)/100")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(skorRenk)
                        Text(saglik.durum)
                            .font(.title3)
                            .foregroundColor(skorRenk)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(skorRenk.opacity(0.1))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Tahmini Kalan")
                                .font(.caption).foregroundColor(.gray)
                            Text("₺\(String(format: "%.0f", kalan))")
                                .font(.title2).bold()
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("İflas Riski")
                                .font(.caption).foregroundColor(.gray)
                            Text(risk.riskli ? "Riskli 🔴" : "Güvenli 💚")
                                .font(.title3).bold()
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("6 Aylık Tahmin")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Chart(grafikVerisi, id: \.ay) { veri in
                            LineMark(
                                x: .value("Ay", veri.ay),
                                y: .value("Bakiye", veri.deger)
                            )
                            .foregroundStyle(risk.riskli ? Color.red : Color.blue)
                            .interpolationMethod(.catmullRom)
                            
                            AreaMark(
                                x: .value("Ay", veri.ay),
                                y: .value("Bakiye", veri.deger)
                            )
                            .foregroundStyle(risk.riskli ? Color.red.opacity(0.1) : Color.blue.opacity(0.1))
                        }
                        .frame(height: 200)
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Kategori Bazlı Harcama")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Chart(kategoriHarcama, id: \.kategori) { veri in
                            BarMark(
                                x: .value("Kategori", veri.kategori),
                                y: .value("Harcama", veri.deger)
                            )
                            .foregroundStyle(Color.purple.opacity(0.7))
                        }
                        .frame(height: 200)
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    BurnRateView(subs: [])
}
