//
//  HomeView.swift
//  FinanceFlow
//
//  Created by HAVVA on 4.03.2026.
//

import SwiftUI

struct HomeView: View{
    
    @State private var showAddSubscription = false
    @State private var subscriptions: [Subscription] = []
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Toplam Aylık Harcama ")
                Text(String(format: "₺%.2f", subscriptions.reduce(0) { $0 + $1.price }))
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.blue)
                
                
                List {
                    ForEach(subscriptions) { sub in
                        NavigationLink(destination: SubscriptionDetailView(subscription: sub)){
                            HStack{
                                VStack(alignment: .leading) {
                                    Text(sub.name)
                                        .font(.headline)
                                    Text("Her ay ödenir")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                    
                                }
                                Spacer()
                                Text(String(format: "₺%.2f", sub.price))
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                        .onDelete { indexSet in subscriptions.remove(atOffsets: indexSet)
                        }
                    }
                    .navigationTitle("FinanceFlow")
                    .toolbar{
                        Button(action: {showAddSubscription = true}) {
                            Image(systemName: "plus")
                        }
                        .sheet(isPresented: $showAddSubscription) {
                            AddSubscriptionView(onSave: { subscription in
                                subscriptions.append(subscription)
                            })
                        }
                    }
                }
            }
        }
    }
    
#Preview {
    HomeView()
}

