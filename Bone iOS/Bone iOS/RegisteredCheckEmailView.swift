//
//  RegisteredCheckEmailView.swift
//  Bone iOS
//
//  Created by Derek Stephen McLean on 13/06/2020.
//  Copyright © 2020 Derek Stephen McLean. All rights reserved.
//

import SwiftUI

struct RegisteredCheckEmailView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image("skull_and_crossbones")
                    .resizable()
                    .frame(width: 200, height: 140)
                Text("CHECK YOUR EMAIL")
                    .font(.title)
                    .padding(.bottom)
                    .foregroundColor(Color.white)
                HStack {
                    NavigationLink(destination: RegisterView()) {
                        Text("BACK")
                        .foregroundColor(Color.white)
                        .padding()
                    }
                    .background(Color.green)
                }
                Spacer()
            }.background(Image("intro-bg"))
        }
        .navigationBarBackButtonHidden(true)
        .accentColor(Color.white)
    }
}

struct RegisteredCheckEmailView_Previews: PreviewProvider {
    static var previews: some View {
        RegisteredCheckEmailView()
    }
}
