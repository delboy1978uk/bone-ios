//
//  SignInView.swift
//  Bone iOS
//
//  Created by Derek Stephen McLean on 10/04/2020.
//  Copyright © 2020 Derek Stephen McLean. All rights reserved.
//

import SwiftUI

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingAlert = false
    @State private var isLoggedIn = false
    
    var body: some View {
        VStack {
            Image("skull_and_crossbones")
                .resizable()
                .frame(width: 100, height: 70)
            Text("LOG IN")
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
                    placeholder: Text("Password..").foregroundColor(.gray),
                    text: $password
                )
                    .padding()
                    .background(Color.white)
                    .foregroundColor(Color.black)
                    .accentColor(Color.gray)
                    .autocapitalization(.none)
                HStack {
                    Spacer()
                    Button(action: logIn) {
                        Text("Log In")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(Color.white)
                    }
                }
            }
            .padding()
            .background(Color.gray)
            NavigationLink(destination: HomeView(), isActive: self.$isLoggedIn) {
                Text("")
            }
            Spacer()
           
        }
        .background(Image("intro-bg"))
        .padding()
    }
    
    func logIn() {
        let oauth2 = OAuthManager.shared.oauth2
        oauth2.authorize(params: nil) { authParameters, error in
            if let params = authParameters {
                print("Authorized! Access token is in `oauth2.accessToken`")
                print("Authorized! Additional parameters: \(params)")
                self.isLoggedIn = true;
            }
            else {
                print("Authorization was canceled or went wrong: \(String(describing: error))")   // error will not be nil
            }
        }
    }
    

}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
