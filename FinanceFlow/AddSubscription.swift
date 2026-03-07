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
    var onSave: (Subscription) -> Void
    var onDismiss: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section("Abonelik Bilgileri") {
                    TextField("Abonelik Adı (Netflix, Spotify...)", text: $name)
                    TextField("Aylık Ücret (₺)", text: $price)
                        .keyboardType(.decimalPad)
                    DatePicker("Ödeme Tarihi", selection: $paymentDate, displayedComponents: .date)
                }
                
                Section {
                    Button("Kaydet") {
                        let newSub = Subscription(
                            name: name,
                            price: Double(price) ?? 0,
                            paymentDate: paymentDate
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
