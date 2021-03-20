//
//  AddButton.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-03-19.
//

import SwiftUI

struct AddButton: View {
    
    var title: String
    var selected: Bool = false
    
    var body: some View {
        ZStack {
            HStack{
                Button{
                    
                }label:{
                    Text(title)
                        .foregroundColor(Color.black)
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 15)
  
                }
            }
        }
        .frame(width: 200, height: 80)
        .cornerRadius(25)
        .border(Color.gray)
        
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        AddButton(title: "")
    }
}
