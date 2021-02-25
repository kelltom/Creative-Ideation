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
        HStack(spacing: 20){
            
            Button{
                // select sub group
            } label: {
                Image(systemName: "folder.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:50, height: 50)
                    .foregroundColor(Color.yellow)
                    .padding()
                
                Text(title)
                    .font(.title2)
                    .fontWeight(selected ? .bold : .regular)
                    .foregroundColor(selected ? Color.white : Color.black)
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .background(selected ? Color("darkCyan") : Color.white)
        .cornerRadius(10)
    }
}

struct SubGroup_Previews: PreviewProvider {
    static var previews: some View {
        SubGroup()
    }
}
