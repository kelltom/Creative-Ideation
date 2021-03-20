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
            HStack {
                Text(title)
                    .font(.title3)
                    .fontWeight(selected ? .bold : .regular)
                    .foregroundColor(selected ? Color.white : Color.black)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 140)
            }
            
            HStack{
                Spacer()
                OptionsButton()
                    .foregroundColor(selected ? Color.white : Color.black)
                    .padding(7)
            }
        }
        .frame(width: 200, height: 80)
        .background(selected ? Color("brandPrimary") : Color.white)
        .cornerRadius(25)
    }
}

struct SubGroup_Previews: PreviewProvider {
    static var previews: some View {
        SubGroup(title: "Example", selected: true)
    }
}

