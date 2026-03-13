//
//  ContentView.swift
//  FinanceFlow
//  Created by HAVVA on 4.03.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showRegister = false
    @State private var isLoggedIn = false
    
    var body: some View {
        if  isLoggedIn {
            HomeView()
        } else{
            
            VStack(spacing: 20) {
                Text("FinanceFlow")
                    .font(.largeTitle)
                    .bold()
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                SecureField("Şifre", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button("Giriş Yap") {
                    isLoggedIn = true
                }
                .buttonStyle(.borderedProminent)
                
                Button("Hesabın yok mu? Kayıt Ol"){
                    showRegister = true
                }
                .sheet(isPresented:  $showRegister){
                    RegisterView()
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
