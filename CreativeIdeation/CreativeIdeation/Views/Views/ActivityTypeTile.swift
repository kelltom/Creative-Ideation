//
//  ActivityTypeTile.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-27.
//

import SwiftUI

struct ActivityTypeTile: View {
    
    var title: String = "Blank Canvas"
    var symbol_name: String = "paintbrush.pointed.fill"
    var selected: Bool = false
    
    var body: some View {
        
        VStack{
            
            Button {
                // Select activity type
            } label: {
                Image(systemName: symbol_name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .padding(40)
                    .foregroundColor(selected ? Color.white : Color.black)
                    .background(selected ? Color("darkCyan") : Color.white)
                    .cornerRadius(30)
                    .clipped()
                    .shadow(color: .black, radius: 4, y: 4)
            }
            
            Text(title)
                .font(.title)
        }
    }
}

struct ActivityTypeTile_Previews: PreviewProvider {
    static var previews: some View {
        ActivityTypeTile()
    }
}
