//
//  HomeView.swift
//  Bone iOS
//
//  Created by Derek Stephen McLean on 27/04/2020.
//  Copyright © 2020 Derek Stephen McLean. All rights reserved.
//

import SwiftUI

struct HomeView: View {
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
                Text("Now grab user details from API!")
                Spacer()
                
            }.background(Image("intro-bg"))
        }
        .accentColor(Color.white)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
