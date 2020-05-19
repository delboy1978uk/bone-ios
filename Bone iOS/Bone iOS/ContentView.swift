//
//  ContentView.swift
//  Bone iOS
//
//  Created by Derek Stephen McLean on 10/04/2020.
//  Copyright © 2020 Derek Stephen McLean. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var hasAccessToken = false
    
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
                    NavigationLink(destination: SignInView()) {
                        Text("Log In")
                            .foregroundColor(Color.white)
                            .padding()
                    }
                    .background(Color.green)
                    Spacer()
                }
                Spacer()
                NavigationLink(destination: HomeView(), isActive: $hasAccessToken) {
                  Text("")
                }.hidden()
            }.background(Image("intro-bg"))
        }
        .accentColor(Color.white)
        .onAppear(perform: checkForClient)
    }
    
    func checkForClient()
    {
        var oauth2 = OAuthManager.shared
        
        if (!oauth2.hasClientRegistered()) {
            let clientId = "da03fbd98f3b52da981b2e50bba4bcd4"
            let clientSecret = "JDJ5JDEwJGcyY0YweGNsM2dxUVBCZDg2NFlrVk81bDQuMW55blJPS09GT3cyMERIRWhISUM4RTdLa29T"
            oauth2.registerClient(clientID: clientId, clientSecret: clientSecret)
        }
        
        oauth2.createUserClient()
        self.checkForAccessToken()
    }
    
    func checkForAccessToken() {
        let oauth2 = OAuthManager.shared.getClient()
        if (oauth2.hasUnexpiredAccessToken()) {
            hasAccessToken = true;
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
