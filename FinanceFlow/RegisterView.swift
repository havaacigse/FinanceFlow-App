//
//  RegisterView.swift
//  FinanceFlow
//
//  Created by HAVVA on 4.03.2026.
//

import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    var onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("Kayıt Ol")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                
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
                
                SecureField("Şifre Tekrar", text: $confirmPassword)
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
                    register()
                } label: {
                    Text("Kayıt Ol")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                }
                
                Button("Zaten hesabın var mı? Giriş Yap") {
                    onDismiss()
                }
                .foregroundColor(.white)
            }
            .padding(.horizontal, 24)
        }
    }
    func register() {
        guard password == confirmPassword else {
            errorMessage = "Şifreler eşleşmiyor"
            return
        }
        let fakeEmail = email.lowercased() + "@financeflow.com"
        Auth.auth().createUser(withEmail: fakeEmail, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                onDismiss()
            }
        }
    }
}

#Preview {
    RegisterView(onDismiss: {})
}
