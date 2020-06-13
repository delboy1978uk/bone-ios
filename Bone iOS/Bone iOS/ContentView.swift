//
//  ContentView.swift
//  Bone iOS
//
//  Created by Derek Stephen McLean on 10/04/2020.
//  Copyright © 2020 Derek Stephen McLean. All rights reserved.
//

import Alamofire
import Foundation
import Moya
import OAuth2
import SwiftUI

struct ContentView: View {
    
    @State private var hasClientAccessToken: Bool = true {
        didSet {
            if (hasClientAccessToken) {
                print("registation client has an access token, checking user client is registered")
                checkUserClientHasBeenRegistered()
            } else {
                print ("registration client has no access token, now authenticating...")
                authenticateRegistrationClient()
            }
        }
    }
    @State private var hasUserClient: Bool = false {
        didSet {
            if (hasUserClient) {
                print ("user client details found in keychain, checking client has been created")
                checkUserClientHasBeenInitialised()
            } else {
                print ("device has not been registered, registering for new client details")
                callRegistrationEndpoint()
            }
        }
    }
    @State private var userClientIsInitialised: Bool = false {
        didSet {
            if (userClientIsInitialised) {
                print ("user client has now been instantiated, checking for access token...")
                checkForAccessToken()
            } else {
                print ("user client not present, creating")
                initUserClient()
            }
        }
    }
    @State var hasUserAccessToken = false
    
    @State private var oauth2: OAuthManager = OAuthManager.shared
    
    var body: some View {
        NavigationView {
            VStack {
                Image("skull_and_crossbones")
                    .resizable()
                    .frame(width: 200, height: 140)
                Text("BONE FRAMEWORK")
                    .font(.title)
                    .padding(.bottom)
                    .foregroundColor(Color.white)
                HStack {
                    Spacer()
                    NavigationLink(destination: RegisterView()) {
                        Text("Register")
                            .foregroundColor(Color.white)
                            .padding()
                    }
                    .background(Color.red)
                    Spacer()
                    Button(action: logIn) {
                        Text("Log In")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(Color.white)
                    }
                    .background(Color.green)
                    Spacer()
                }
                Spacer()
                NavigationLink(destination: HomeView(), isActive: $hasUserAccessToken) {
                  Text("")
                }.hidden()
            }.background(Image("intro-bg"))
        }
        .navigationBarBackButtonHidden(true)
        .accentColor(Color.white)
        .onAppear(perform: initialiseApp)
    }
        
    func initialiseApp()
    {
        if (!oauth2.registrationClient.hasUnexpiredAccessToken()) {
            hasClientAccessToken = false
        } else {
            hasClientAccessToken = true
        }
    }
    
    func checkUserClientHasBeenRegistered() {
        if (oauth2.hasClientRegistered()) {
            hasUserClient = true
        } else {
            hasUserClient = false
        }
    }
    
    func checkForAccessToken() {
        let oauth2 = self.oauth2.getClient()
        if (oauth2.hasUnexpiredAccessToken()) {
            hasUserAccessToken = true;
        } else {
            hasUserAccessToken = false;
            print("no access token found, user needs to authenticate")
        }
    }
    
    func checkUserClientHasBeenInitialised() {
        if (oauth2.hasUserClientInitialised()) {
            userClientIsInitialised = true
        } else {
            userClientIsInitialised = false
        }
    }
    
    func initUserClient() {
        oauth2.initUserClient()
        userClientIsInitialised = true
    }
    
    func authenticateRegistrationClient() {
        let oauth2 = self.oauth2.registrationClient
//        oauth2.logger = OAuth2DebugLogger(.trace)
        print("Authorising registration client...")
        oauth2.authorize(params: nil) { authParameters, error in
            if authParameters != nil {
                print("Authorized! Access token is `\(String(describing: oauth2.accessToken))`")
                self.hasClientAccessToken = true
            }
            else {
                print("Authorization was canceled or went wrong: \(String(describing: error))")

            }
        }
    }
    
    func callRegistrationEndpoint()
    {
        let oauth2 = self.oauth2.registrationClient
        let retrier = OAuth2RetryHandler(oauth2: oauth2)
        let configuration = URLSessionConfiguration.default
        let sessionManager = Session(configuration: configuration, interceptor: retrier)
        let provider = MoyaProvider<ApiServices>(session: sessionManager)
    
        provider.request(.registerClient) { (result) in
            switch result {
            case let .success(response):
                do {
                    let jsonString = try response.mapString()
                    let data = Data(jsonString.utf8)
                    do {
                        // make sure this JSON is in the format we expect
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
                            // try to read out a string array
                            let clientId:  String  = json["client_id"]!
                            let clientSecret:  String  = json["client_secret"]!
                            OAuthManager.shared.storeClient(clientID: clientId, clientSecret: clientSecret)
                            self.hasUserClient = true
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                }
                catch let error {
                    debugPrint("Unknown error:\(error)")
                }
            case let .failure(error):
                debugPrint("Client registration error:\(error)")
                break
            }
        }
//        oauth2.logger = OAuth2DebugLogger(.trace)
    }
    
    
    func logIn() {
        let oauth2 = OAuthManager.shared.getClient()

        oauth2.logger = OAuth2DebugLogger(.trace)
        oauth2.authorize(params: nil) { authParameters, error in
            if authParameters != nil {
                print("Authorized! Access token is `\(String(describing: oauth2.accessToken))`")
                self.hasUserAccessToken = true
            }
            else {
                print("Authorization was canceled or went wrong: \(String(describing: error))")

            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
