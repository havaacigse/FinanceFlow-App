//
//  HomeView.swift
//  FinanceFlow
//
//  Created by HAVVA on 4.03.2026.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var showAddSubscription = false
    @State private var showBurnRate = false
    @State private var showProfile = false
    var onLogout: () -> Void

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    VStack(spacing: 8) {
                        Spacer()
                            .frame(height: 40)
                        Text("Toplam Aylık Harcama")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))

                        Text(String(format: "₺%.2f", viewModel.totalMonthly))
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.white)

                        Text("\(viewModel.subscriptions.count) aktif abonelik")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))

                        Spacer()
                            .frame(height: 20)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                    .background(
                        LinearGradient(
                            colors: [Color.blue, Color.purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .overlay(alignment: .topTrailing) {
                        HStack {
                            Button(action: { showAddSubscription = true }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            Button(action: onLogout) {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            Button(action: { showBurnRate = true }) {
                                Image(systemName: "brain.head.profile")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            Button(action: { showProfile = true }) {
                                Image(systemName: "person.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        }
                    }

                    content
                }
            }
            .sheet(isPresented: $showBurnRate) {
                BurnRateView(subs: viewModel.subscriptions)
            }
            .sheet(isPresented: $showProfile) {
                ProfileView(subscriptions: viewModel.subscriptions)
            }
            .navigationBarHidden(true)
            .task(id: viewModel.reloadID) {
                await viewModel.start()
            }
            .sheet(isPresented: $showAddSubscription) {
                AddSubscriptionView(
                    onSave: { subscription in
                        Task { await viewModel.save(subscription) }
                    },
                    onDismiss: { showAddSubscription = false }
                )
            }
            .alert(
                "Hata",
                isPresented: Binding(
                    get: { viewModel.actionErrorMessage != nil },
                    set: { isPresented in
                        if !isPresented { viewModel.actionErrorMessage = nil }
                    }
                )
            ) {
                Button("Tamam", role: .cancel) {}
            } message: {
                Text(viewModel.actionErrorMessage ?? "")
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let message = viewModel.listErrorMessage {
            VStack(spacing: 12) {
                Text(message)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                Button("Tekrar Dene") { viewModel.retry() }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        } else if viewModel.subscriptions.isEmpty {
            Text("Henüz abonelik eklemedin")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List {
                ForEach(viewModel.subscriptions) { sub in
                    NavigationLink(destination: SubscriptionDetailView(
                        subscription: sub,
                        onSave: { updated in
                            Task { await viewModel.save(updated) }
                        }
                    )) {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.1))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "creditcard.fill")
                                    .foregroundColor(.blue)
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text(sub.name)
                                    .font(.headline)
                                Text(sub.category.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text(String(format: "₺%.2f", sub.price))
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let sub = viewModel.subscriptions[index]
                        Task { await viewModel.delete(sub) }
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
    }
}

#Preview {
    HomeView(onLogout: {})
}
