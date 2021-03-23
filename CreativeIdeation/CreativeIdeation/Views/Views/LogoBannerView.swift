//
//  LogoBannerView.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-02-17.
//

import SwiftUI

struct LogoBannerView: View {
    var body: some View {
        HStack {
            Image(systemName: "applelogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(Color("brandPrimary"))

            Text("Ponder")
                .font(.largeTitle)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .scaledToFit()

            Spacer()
        }
        .padding(.top, 30)

    }
}

struct LogoBannerView_Previews: PreviewProvider {
    static var previews: some View {
        LogoBannerView()
    }
}
