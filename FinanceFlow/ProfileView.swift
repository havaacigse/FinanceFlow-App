//
//  ProfileView.swift
//  FinanceFlow
//
//  Created by HAVVA on 14.03.2026.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    let subscriptions: [Subscription]
    
    var kullaniciAdi: String {
        let email = Auth.auth().currentUser?.email ?? ""
        return email.components(separatedBy: "@").first ?? "Kullanıcı"
    }
    
    var toplamYillik: Double {
        subscriptions.reduce(0) { $0 + $1.price } * 12
    }
    
    var enPahalı: Subscription? {
        subscriptions.max(by: { $0.price < $1.price })
    }
    
    var kategoriler: [String: Double] {
        Dictionary(grouping: subscriptions, by: { $0.category.rawValue })
            .mapValues { $0.reduce(0) { $0 + $1.price } }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                // Profil
                VStack(spacing: 8) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text("Merhaba, \(kullaniciAdi)!")
                        .font(.title2).bold()
                    
                    Text("\(subscriptions.count) aktif abonelik")
                        .foregroundColor(.gray)
                }
                .padding()
                
                // Özet kartlar
                HStack(spacing: 12) {
                    VStack(spacing: 4) {
                        Text("Aylık")
                            .font(.caption).foregroundColor(.gray)
                        Text(String(format: "₺%.0f", subscriptions.reduce(0) { $0 + $1.price }))
                            .font(.title3).bold().foregroundColor(.blue)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                    
                    VStack(spacing: 4) {
                        Text("Yıllık")
                            .font(.caption).foregroundColor(.gray)
                        Text(String(format: "₺%.0f", toplamYillik))
                            .font(.title3).bold().foregroundColor(.purple)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // En pahalı abonelik
                if let pahalı = enPahalı {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("En Pahalı Abonelik")
                            .font(.headline)
                        HStack {
                            Text(pahalı.name)
                            Spacer()
                            Text(String(format: "₺%.2f", pahalı.price))
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .background(Color.red.opacity(0.05))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                // Kategori dağılımı
                VStack(alignment: .leading, spacing: 12) {
                    Text("Kategori Dağılımı")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(kategoriler.sorted(by: { $0.value > $1.value }), id: \.key) { kategori, tutar in
                        HStack {
                            Text(kategori)
                            Spacer()
                            Text(String(format: "₺%.2f", tutar))
                                .foregroundColor(.blue)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .padding(.top)
        }
    }
}

#Preview {
    ProfileView(subscriptions: [])
}
