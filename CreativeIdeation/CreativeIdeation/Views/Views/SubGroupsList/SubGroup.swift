//
//  SubGroup.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-25.
//

import SwiftUI

struct SubGroup: View {
    
    var title: String = "Example"
    var selected: Bool = false
    
    var body: some View {
        ZStack {
            HStack{
                Text(title)
                    .font(.title2)
                    .fontWeight(selected ? .bold : .regular)
                    .foregroundColor(selected ? Color.white : Color.black)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 180)
            }
            
            HStack{
                Spacer()
                OptionsButton()
                    .foregroundColor(selected ? Color.white : Color.black)
                    .padding(10)
            }
        }
        .frame(width: 250, height: 80)
        .background(selected ? Color("darkCyan") : Color.white)
        .cornerRadius(25)
    }
}

struct SubGroup_Previews: PreviewProvider {
    static var previews: some View {
        SubGroup()
    }
}
