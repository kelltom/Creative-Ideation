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
            .frame(width: 550, height: 60, alignment: .center)
            .background(Color("darkCyan"))
            .foregroundColor(.white)
            .cornerRadius(10)
            .font(.title2)
            .padding()
            .shadow(radius: 5, x: 5, y: 5)
    }
}

struct BigButton_Previews: PreviewProvider {
    static var previews: some View {
        BigButton(title: "Sample Title")
    }
}
