//
//  AddSubscription.swift
//  FinanceFlow
//
//  Created by HAVVA on 4.03.2026.
//


import SwiftUI

struct AddSubscriptionView: View {
    @State private var name = ""
    @State private var price = ""
    @State private var paymentDate = Date()
    @State private var category: SubscriptionCategory = .diger
    var onSave: (Subscription) -> Void
    var onDismiss: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section("Abonelik Bilgileri") {
                    TextField("Abonelik Adı (Netflix, Spotify...)", text: $name).onChange(of: name) { _ in category = Subscription.kategoriTahmin(isim: name)}
                    TextField("Aylık Ücret (₺)", text: $price)
                        .keyboardType(.decimalPad)
                    DatePicker("Ödeme Tarihi", selection: $paymentDate, displayedComponents: .date)
                    Picker("Kategori", selection: $category) {
                        ForEach(SubscriptionCategory.allCases, id: \.self) { cat in Text(cat.rawValue).tag(cat)
                        }
                    }
                }
                
                Section {
                    Button("Kaydet") {
                        let newSub = Subscription(
                            name: name,
                            price: Double(price) ?? 0,
                            paymentDate: paymentDate,
                            category: category
                        )
                        onSave(newSub)
                        onDismiss()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.blue)
                }
            }
            .navigationTitle("Abonelik Ekle")
            .toolbar {
                Button("İptal") {
                    onDismiss()
                }
            }
        }
    }
}

#Preview {
    AddSubscriptionView(onSave: { _ in }, onDismiss: {})
}
