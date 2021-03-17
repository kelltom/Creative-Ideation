//
//  DeleteButton.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-03-17.
//

import SwiftUI

struct DeleteButton: View {
    var image: String = "trash.fill"
    var body: some View {
       
            Text("Delete Team")
                .fontWeight(.bold)
                .font(.body)
                .frame(width:200, height:50, alignment: .center)
                .background(Color(.red))
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
        
    }
    
}

struct DeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteButton()
    }
}
