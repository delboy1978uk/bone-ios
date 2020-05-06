//
//  RegisterView.swift
//  Bone iOS
//
//  Created by Derek Stephen McLean on 10/04/2020.
//  Copyright © 2020 Derek Stephen McLean. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            Image("skull_and_crossbones")
                .resizable()
                .frame(width: 100, height: 70)
            Text("REGISTER")
                .font(.title)
                .padding(.bottom)
                .foregroundColor(Color.white)
            VStack {
                BoneTextField(
                    placeholder: Text("Email address..").foregroundColor(.gray),
                    text: $email
                )
                    .padding()
                    .background(Color.white)
                    .foregroundColor(Color.black)
                    .accentColor(Color.gray)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                BoneSecureField(
                    placeholder: Text("Choose a password..").foregroundColor(.gray),
                    text: $password
                )
                    .padding()
                    .background(Color.white)
                    .foregroundColor(Color.black)
                    .accentColor(Color.gray)
                    .autocapitalization(.none)
                HStack {
                    Spacer()
                    Button(action: register) {
                        Text("Register")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(Color.white)
                    }
                }
                
            }
            .padding()
            .background(Color.gray)
            Spacer()
        }.background(Image("intro-bg"))
        
    }
    
    func register() {
        
        let oauth2 = OAuthManager.shared.registrationClient
        oauth2.authConfig.authorizeEmbedded = true
        oauth2.authConfig.authorizeContext = self as AnyObject
        oauth2.authorize(params: nil) { (json, error) in
            debugPrint("auth: json:\(String(describing: json)). error: \(String(describing: error))")
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
