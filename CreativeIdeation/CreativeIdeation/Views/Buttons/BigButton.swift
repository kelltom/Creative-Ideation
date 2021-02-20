//
//  BigButton.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-02-19.
//

import SwiftUI

struct BigButton: View {
    
    var title: String
    
    var body: some View {
        Text(title)
            .padding()
            .frame(width: 550, height: 60, alignment: .center)
            .background(Color("darkCyan"))
            .foregroundColor(.white)
            .overlay(RoundedRectangle(cornerRadius: 8.0).stroke(Color.black))
            .font(.title2)
    }
}

struct BigButton_Previews: PreviewProvider {
    static var previews: some View {
        BigButton(title: "Sample Title")
    }
}
