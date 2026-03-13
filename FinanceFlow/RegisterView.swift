//
//  RegisterView.swift
//  FinanceFlow
//
//  Created by HAVVA on 4.03.2026.
//

import SwiftUI

struct RegisterView: View{
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View{
        VStack(spacing: 20){
            Text("Kayıt Ol")
                .font(.largeTitle)
                .bold()
            
            TextField("Email",text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            SecureField("Şifre", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            SecureField("Şifre Tekrar", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button("Kayıt Ol") {
                //sonra
            }
            .buttonStyle(.borderedProminent)
            
            
            
        }
    }
}
#Preview {
    RegisterView()
}

