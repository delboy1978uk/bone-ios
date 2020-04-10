//
//  ContentView.swift
//  Bone iOS
//
//  Created by Derek Stephen McLean on 10/04/2020.
//  Copyright © 2020 Derek Stephen McLean. All rights reserved.
//

import SwiftUI

struct ContentView: View {
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
            }.background(Image("intro-bg"))
        }
        .accentColor(Color.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
