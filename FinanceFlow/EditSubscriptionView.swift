//
//  EditSubscriptionView.swift
//  FinanceFlow
//
//  Created by HAVVA on 5.03.2026.
//


import SwiftUI

struct EditSubscriptionView: View {
    @State var subscription: Subscription
    var onSave: (Subscription) -> Void
    var onDismiss: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section("Abonelik Bilgileri"){
                    TextField("Abonelik Adı", text: $subscription.name)
                    TextField("Aylık Ücret", value: $subscription.price, format: .number)
                        .keyboardType(.decimalPad)
                    
                    DatePicker("Ödeme Tarihi", selection: $subscription.paymentDate, displayedComponents: .date)
                }
                
                Section {
                    Button("Kaydet") {
                        onSave(subscription)
                        onDismiss()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.blue)
                }
                
            }
            .navigationTitle("Düzenle")
            .toolbar {
                Button("İptal"){
                   onDismiss()
                }
            }
        }
    }
}

#Preview {
    EditSubscriptionView(
        subscription: Subscription(name: "Netflix", price: 149.99, paymentDate: Date()),
        onSave: { _ in },
        onDismiss: {}
    )
}
