//
//  HomeView.swift
//  Bone iOS
//
//  Created by Derek Stephen McLean on 27/04/2020.
//  Copyright © 2020 Derek Stephen McLean. All rights reserved.
//

import Alamofire
import Foundation
import Moya
import OAuth2
import SwiftUI

struct HomeView: View {
    
    var user: BoneUser? = nil
    
    @State private var email: String = ""
    @State private var name: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Image("skull_and_crossbones")
                    .resizable()
                    .frame(width: 200, height: 140)
                Text("WELCOME")
                    .font(.title)
                    .padding(.bottom)
                    .foregroundColor(Color.white)
                Text(name)
                    .font(.title)
                    .foregroundColor(Color.white)
                Text(email)
                    .foregroundColor(Color.white)
                Spacer()
                
            }.background(Image("intro-bg"))
        }
        .accentColor(Color.white)
        .onAppear(perform: fetchUser)
    }
    
    private func fetchUser() {
        let oauth2 = OAuthManager.shared.getClient()
        oauth2.logger = OAuth2DebugLogger(.trace)
        let retrier = OAuth2RetryHandler(oauth2: oauth2)
        let configuration = URLSessionConfiguration.default
        let sessionManager = Session(configuration: configuration, interceptor: retrier)
        

        let provider = MoyaProvider<ApiServices>(session: sessionManager)
        provider.request(.getProfile) { (result) in
            switch result {
            case let .success(response):
                do {

                    debugPrint("Response:\(try response.mapString())")
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let person = try filteredResponse.map(BonePerson.self, atKeyPath: "person", using: decoder, failsOnEmptyData: false)
                    let user = try filteredResponse.map(BoneUser.self, atKeyPath: "", using: decoder, failsOnEmptyData: false)
                    user.person = person
                    self.email = user.email
                    self.name = (person.firstname ?? "") + " " + (person.lastname ?? "")
                }
                catch let error {
                    debugPrint("Bone account error:\(error)")
                }
            case let .failure(error):
                debugPrint("User account failure error:\(error)")
                debugPrint("User account failure error:\(result)")
                break
            }
        }
        oauth2.logger = OAuth2DebugLogger(.trace)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
