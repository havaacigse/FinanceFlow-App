//
//  ContentView.swift
//  FinanceFlow
//  Created by HAVVA on 4.03.2026.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var showRegister = false
    @State private var errorMessage = ""
    
    var body: some View {
        if isLoggedIn {
            HomeView()
        } else {
            ZStack {
                LinearGradient(
                    colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Spacer()
                    
                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 70))
                        .foregroundColor(.white)
                    
                    Text("FinanceFlow")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Aboneliklerini akıllıca yönet")
                        .foregroundColor(.white.opacity(0.8))
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        TextField("Kullanıcı Adı", text: $email)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .autocapitalization(.none)
                        
                        SecureField("Şifre", text: $password)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                        
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                        Button {
                            login()
                        } label: {
                            Text("Giriş Yap")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        
                        Button("Hesabın yok mu? Kayıt Ol") {
                            showRegister = true

                        
                            
                        }
                        .foregroundColor(.white)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
            }
            .sheet(isPresented: $showRegister) {
                RegisterView(onDismiss: { showRegister = false })
            }
            .onAppear {
                Auth.auth().addStateDidChangeListener { _, user in
                    isLoggedIn = user != nil
                }
            }
        }
    }
    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Kullanıcı adı ve şifre boş olamaz"
            return
        }
        let fakeEmail = email.lowercased() + "@financeflow.com"
        Auth.auth().signIn(withEmail: fakeEmail, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                isLoggedIn = true
            }
        }
    }
    
}

#Preview {
    ContentView()
}

