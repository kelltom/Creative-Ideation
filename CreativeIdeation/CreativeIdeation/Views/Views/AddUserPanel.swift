//
//  AddUserPanel.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-03-13.
//

import SwiftUI

struct AddUserPanel: View {
    var name: String = "mr poopyhead"
    
    var body: some View {
        HStack {
            Text(name).font(.title3)
            Image(systemName: "xmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 15, height:15)
        }
        .padding()
        .frame(minHeight: 50)
        .background(Color("darkCyan"))
        .foregroundColor(.white)
        .cornerRadius(20)
        .shadow(color: .black, radius: 4, y:4 )
    }
}

struct AddUserPanel_Previews: PreviewProvider {
    static var previews: some View {
        AddUserPanel()
    }
}
