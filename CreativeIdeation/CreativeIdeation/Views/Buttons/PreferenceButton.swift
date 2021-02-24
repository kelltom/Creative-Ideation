//
//  PreferenceButton.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-02-19.
//

import SwiftUI

struct PreferenceButton: View {
    
    var title: String
    var selected: Bool = false
    
    var body: some View {
        
        Text(title)
            .fontWeight(.bold)
            .font(.system(size: 21))
            .frame(width:200, height:60, alignment: .center)
            .overlay(RoundedRectangle(cornerRadius: 90.0)
                        .stroke(Color.black, lineWidth: 2.0))
            .background(selected ? Color("darkCyan") : .white)
            .foregroundColor(selected ? .white : .black)
            .cornerRadius(90)
            .padding()
    }
    
}

struct PreferenceButton_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceButton(title: "Test Title", selected: true)
    }
}
