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
                .frame(width: 150, height: 150)
                .foregroundColor(Color("darkCyan"))
            
            Text("Ponder")
                .font(.largeTitle)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .scaledToFit()
            
            Spacer()
        }
        .padding(.leading, 30)
        
    }
}

struct LogoBannerView_Previews: PreviewProvider {
    static var previews: some View {
        LogoBannerView()
    }
}
