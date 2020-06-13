//
//  RegisterView.swift
//  Bone iOS
//
//  Created by Derek Stephen McLean on 10/04/2020.
//  Copyright © 2020 Derek Stephen McLean. All rights reserved.
//


import Moya
import SwiftUI

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirm: String = ""
    @State private var emailBorder: CGFloat = 0
    @State private var passwordBorder: CGFloat = 0
    @State private var confirmBorder: CGFloat = 0
    @State private var errorText: String = ""
    @State private var emailErrorText: String = ""
    @State private var passwordErrorText: String = ""
    @State private var confirmErrorText: String = ""
    
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
                Text(errorText)
                    
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
                    .border(Color.red, width: emailBorder)
                Text(emailErrorText)
                BoneSecureField(
                    placeholder: Text("Choose a password..").foregroundColor(.gray),
                    text: $password
                )
                    .padding()
                    .background(Color.white)
                    .foregroundColor(Color.black)
                    .accentColor(Color.gray)
                    .autocapitalization(.none)
                    .border(Color.red, width: passwordBorder)
                Text(passwordErrorText)
                BoneSecureField(
                    placeholder: Text("Confirm your password..").foregroundColor(.gray),
                    text: $confirm
                )
                    .padding()
                    .background(Color.white)
                    .foregroundColor(Color.black)
                    .accentColor(Color.gray)
                    .autocapitalization(.none)
                    .border(Color.red, width: confirmBorder)
                Text(confirmErrorText)
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
    
    func resetErrorMessages()
    {
        self.errorText = ""
        self.emailErrorText = ""
        self.passwordErrorText = ""
        self.confirmErrorText = ""
        self.emailBorder = 0
        self.passwordBorder = 0
        self.confirmBorder = 0
    }
    
    func register() {
        resetErrorMessages()

        let oauth2 = OAuthManager.shared.registrationClient
        let retrier = OAuth2RetryHandler(oauth2: oauth2)
        let configuration = URLSessionConfiguration.default
        let sessionManager = Session(configuration: configuration, interceptor: retrier)
        let provider = MoyaProvider<ApiServices>(session: sessionManager)
    
        provider.request(.registerUser(email: email, password: password, confirm: confirm)) { (result) in
            switch result {
            case let .success(response):
                do {
                    let jsonString = try response.mapString()
                    let data = Data(jsonString.utf8)
                    debugPrint(jsonString)
                    do {
                        // make sure this JSON is in the format we expect
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            // try to read out a string array
                            if let error = json["error"] as? [String:[String]] {
                                for (key, value) in error {
                                    if (key == "email") {
                                        self.emailBorder = 2.0
                                        self.emailErrorText = value[0]
                                    } else if (key == "password") {
                                        self.passwordBorder = 2.0
                                        self.passwordErrorText = value[0]
                                    }else if (key == "confirm") {
                                        self.confirmBorder = 2.0
                                        self.confirmErrorText = value[0]
                                    }
                                }
                            } else if let error = json["error"] as? String {
                                self.errorText = error
                            } else {
                                // handle success
                            }

                        
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                }
                catch let error {
                    debugPrint("Unknown error:\(error)")
                }
            case let .failure(error):
                debugPrint("User registration error:\(error)")
                break
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
