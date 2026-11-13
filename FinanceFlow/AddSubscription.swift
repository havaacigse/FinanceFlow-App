//
//  AddSubscription.swift
//  FinanceFlow
//
//  Created by HAVVA on 4.03.2026.
//


import SwiftUI

struct AddSubscriptionView: View {
    @State private var viewModel = SubscriptionFormViewModel(mode: .new)
    var onSave: (Subscription) -> Void
    var onDismiss: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section("Abonelik Bilgileri") {
                    TextField("Abonelik Adı (Netflix, Spotify...)", text: $viewModel.name)
                        .onChange(of: viewModel.name) { _, _ in
                            viewModel.predictCategoryFromName()
                        }
                    if let message = viewModel.nameErrorMessage {
                        Text(message)
                            .font(.caption)
                            .foregroundColor(.red)
                    }

                    TextField("Aylık Ücret (₺)", text: $viewModel.priceText)
                        .keyboardType(.decimalPad)
                    if let message = viewModel.priceErrorMessage {
                        Text(message)
                            .font(.caption)
                            .foregroundColor(.red)
                    }

                    DatePicker("Ödeme Tarihi", selection: $viewModel.paymentDate, displayedComponents: .date)
                    Picker("Kategori", selection: Binding(
                        get: { viewModel.category },
                        set: { viewModel.setCategory($0) }
                    )) {
                        ForEach(SubscriptionCategory.allCases, id: \.self) { cat in Text(cat.rawValue).tag(cat)
                        }
                    }
                }

                Section {
                    Button("Kaydet") {
                        if let subscription = viewModel.makeSubscription() {
                            onSave(subscription)
                            onDismiss()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.blue)
                    .disabled(!viewModel.isValid)
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
