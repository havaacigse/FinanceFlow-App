//
//  HomeView.swift
//  FinanceFlow
//
//  Created by HAVVA on 4.03.2026.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct HomeView: View {
    @State private var showAddSubscription = false
    @State private var showBurnRate = false
    @State private var showProfile = false
    @State private var subscriptions: [Subscription] = []
    private let db = Firestore.firestore()
    
    var totalMonthly: Double {
        subscriptions.reduce(0) { $0 + $1.price }
    }
    
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
                        
                        Text(String(format: "₺%.2f", totalMonthly))
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("\(subscriptions.count) aktif abonelik")
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
                            Button(action: { logout() }) {
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
                    
                    List {
                        ForEach(subscriptions) { sub in
                            NavigationLink(destination: SubscriptionDetailView(
                                subscription: sub,
                                onSave: { updated in
                                    updateSubscription(updated)
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
                            indexSet.forEach { i in
                                deleteSubscription(subscriptions[i])
                            }
                            subscriptions.remove(atOffsets: indexSet)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .sheet(isPresented: $showBurnRate){
                BurnRateView(subs: subscriptions)
            }
            .sheet(isPresented: $showProfile) {
                ProfileView(subscriptions: subscriptions)
            }
            
            .navigationBarHidden(true)
            .onAppear { fetchSubscriptions() }
            .sheet(isPresented: $showAddSubscription) {
                AddSubscriptionView(
                    onSave: { subscription in
                        saveSubscription(subscription)
                    },
                    onDismiss: { showAddSubscription = false }
                )
            }
        }
    }
    
    func fetchSubscriptions() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).collection("subscriptions")
            .addSnapshotListener { snapshot, error in
                guard let docs = snapshot?.documents else { return }
                subscriptions = docs.compactMap { doc -> Subscription? in
                    let data = doc.data()
                    guard let name = data["name"] as? String,
                          let price = data["price"] as? Double,
                          let timestamp = data["paymentDate"] as? Timestamp else { return nil }
                    return Subscription(id: UUID(uuidString: doc.documentID) ?? UUID(),
                                        name: name,
                                        price: price,
                                        paymentDate: timestamp.dateValue(),
                                        category: SubscriptionCategory(rawValue: data["category"] as? String ?? "") ?? .diger)
                }
            }
    }
    
    func saveSubscription(_ sub: Subscription) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).collection("subscriptions")
            .document(sub.id.uuidString)
            .setData([
                "name": sub.name,
                "price": sub.price,
                "paymentDate": Timestamp(date: sub.paymentDate),
                "category": sub.category.rawValue
            ])
        bildirimKur(sub)
    }

    func bildirimKur(_ sub: Subscription) {
        let content = UNMutableNotificationContent()
        content.title = "Ödeme Zamanı! 💳"
        content.body = "\(sub.name) aboneliğin bugün yenileniyor: ₺\(String(format: "%.2f", sub.price))"
        content.sound = .default
        
        var dateComponents = Calendar.current.dateComponents([.month, .day], from: sub.paymentDate)
        dateComponents.hour = 9
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: sub.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func updateSubscription(_ sub: Subscription) {
        saveSubscription(sub)
    }
    
    func deleteSubscription(_ sub: Subscription) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).collection("subscriptions")
            .document(sub.id.uuidString)
            .delete()
    }
    func logout() {
        try? Auth.auth().signOut()
    }
}

#Preview {
    HomeView()
}
