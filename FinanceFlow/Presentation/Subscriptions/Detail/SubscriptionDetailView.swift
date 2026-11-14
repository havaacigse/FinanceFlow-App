//
//  SubscriptionDetailView.swift
//  FinanceFlow
//
//  Created by HAVVA on 5.03.2026.
//


import SwiftUI

struct SubscriptionDetailView: View {
    @State private var showEdit = false
    let id: Subscription.ID
    var viewModel: HomeViewModel

    private var subscription: Subscription? {
        viewModel.subscriptions.first(where: { $0.id == id })
    }

    var body: some View {
        Group {
            if let subscription {
                VStack(spacing: 20) {
                    Text(subscription.name)
                        .font(.largeTitle)
                        .bold()

                    Text(String(format: "₺%.2f", NSDecimalNumber(decimal: subscription.price).doubleValue))
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
                .sheet(isPresented: $showEdit) {
                    EditSubscriptionView(
                        subscription: subscription,
                        onSave: { updated in
                            Task { await viewModel.save(updated) }
                        },
                        onDismiss: { showEdit = false }
                    )
                }
            } else {
                Text("Bu abonelik artık mevcut değil")
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Detay")
    }
}

#Preview {
    SubscriptionDetailView(
        id: UUID(),
        viewModel: HomeViewModel()
    )
}
