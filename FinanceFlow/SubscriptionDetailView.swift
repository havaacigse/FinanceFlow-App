//
//  SubscriptionDetailView.swift
//  FinanceFlow
//
//  Created by HAVVA on 5.03.2026.
//


import SwiftUI

struct SubscriptionDetailView: View {
    @State private var showEdit = false
    var subscription: Subscription
    var onSave: (Subscription) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text(subscription.name)
                .font(.largeTitle)
                .bold()
            
            Text(String(format: "₺%.2f", subscription.price))
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.blue)
            
            Text("Ödeme Tarihi")
                .font(.headline)
                .foregroundColor(.gray)
            
            Text(subscription.paymentDate, style: .date)
                .font(.title2)
            
            Button("Düzenle") {
                showEdit = true
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Detay")
        .sheet(isPresented: $showEdit) {
            EditSubscriptionView(
                subscription: subscription,
                onSave: { updated in onSave(updated) },
                onDismiss: { showEdit = false }
            )
        }
    }
}

#Preview {
    SubscriptionDetailView(
        subscription: Subscription(name: "Netflix", price: 149.99, paymentDate: Date()),
        onSave: { _ in }
    )
}
