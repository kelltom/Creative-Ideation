//
//  RecentSession.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-27.
//

import SwiftUI

struct RecentSession: View {
    
    var title: String = "Example"
    
    var body: some View {
        HStack(spacing: 20){
            Image(systemName: "clock.arrow.circlepath")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:50, height: 50)
                .foregroundColor(Color.red)
                .padding()
            
            Text(title)
                .font(.title2)
                .foregroundColor(Color.black)
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity)
        .cornerRadius(10)
    }
}

struct RecentSession_Previews: PreviewProvider {
    static var previews: some View {
        RecentSession()
    }
}
