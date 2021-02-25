//
//  FavouriteSession.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-25.
//

import SwiftUI

struct FavouriteSession: View {
    var title: String = "Example"
    
    var body: some View {
        HStack(spacing: 20){
            
            Button{
                // select sub group
            } label: {
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:50, height: 50)
                    .foregroundColor(Color.yellow)
                    .padding()
                
                Text(title)
                    .font(.title2)
                    .foregroundColor(Color.black)
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .cornerRadius(10)
    }
}

struct FavouriteSession_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteSession()
    }
}
