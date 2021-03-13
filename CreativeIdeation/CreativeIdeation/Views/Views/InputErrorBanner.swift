//
//  InputErrorBanner.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-03-13.
//

import SwiftUI

struct InputErrorBanner: View {
    
    var msg: String = "Error"
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "exclamationmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color.white)
                
                
                Text(msg)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: 100)
            .background(Color.red)
            .cornerRadius(25)
            .padding()
            
            Spacer()
        }
    }
}

struct InputErrorBanner_Previews: PreviewProvider {
    static var previews: some View {
        InputErrorBanner()
    }
}
