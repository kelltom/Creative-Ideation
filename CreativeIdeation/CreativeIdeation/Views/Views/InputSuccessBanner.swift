//
//  InputSuccessBanner.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-03-13.
//

import SwiftUI

struct InputSuccessBanner: View {
    var msg: String = "Success"
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color.white)
                
                
                Text(msg)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: 100)
            .background(Color.green)
            .cornerRadius(25)
            .padding()
            
            Spacer()
        }
        
    }
}

struct InputSuccessBanner_Previews: PreviewProvider {
    static var previews: some View {
        InputSuccessBanner()
    }
}
