//
//  Splash.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-04-15.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color("brandPrimary")
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)

            Image("test")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 225)

        }
    }
}

struct Splash_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
