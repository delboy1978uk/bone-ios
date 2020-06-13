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
    @State private var successfullyRegistered: Bool = false
    @State private var showError: Bool = false
    @State private var showEmailError: Bool = false
    @State private var showPasswordError: Bool = false
    @State private var showConfirmError: Bool = false
    @State private var errorBackground: Color? = nil
    @State private var emailErrorBackground: Color? = nil
    @State private var passwordErrorBackground: Color? = nil
    @State private var confirmErrorBackground: Color? = nil
    
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
                    .frame(maxWidth: .infinity)
                    .isHidden(self.showError)
                    .background(self.errorBackground)
                    .foregroundColor(Color.white)
                    
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
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity)
                    .background(self.emailErrorBackground)
                    .isHidden(self.showEmailError)
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
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity)
                    .isHidden(self.showPasswordError)
                    .background(self.passwordErrorBackground)
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
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity)
                    .isHidden(self.showConfirmError)
                    .background(self.confirmErrorBackground)
                HStack {
                    Spacer()
                    Button(action: register) {
                        Text("Register")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(Color.white)
                    }
                }
                NavigationLink(destination: RegisteredCheckEmailView(), isActive: $successfullyRegistered) {
                    EmptyView()
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
        self.showError = false
        self.showEmailError = false
        self.showPasswordError = false
        self.showConfirmError = false
        self.errorBackground = nil
        self.emailErrorBackground = nil
        self.passwordErrorBackground = nil
        self.confirmErrorBackground = nil
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
                                        self.emailErrorBackground = Color(.red)
                                    } else if (key == "password") {
                                        self.passwordBorder = 2.0
                                        self.passwordErrorText = value[0]
                                        self.passwordErrorBackground = Color(.red)
                                    }else if (key == "confirm") {
                                        self.confirmBorder = 2.0
                                        self.confirmErrorText = value[0]
                                        self.confirmErrorBackground = Color(.red)
                                    }
                                }
                            } else if let error = json["error"] as? String {
                                self.errorText = error
                                self.errorBackground = Color(.red)
                            } else {
                                self.successfullyRegistered = true;
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
