//
//  TextEditButton.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-03-17.
//

import SwiftUI

struct TextEditButton: View {

    var body: some View {
        Text("Edit")
            .fontWeight(.bold)
            .font(.body)
            .frame(width: 100, height: 40, alignment: .center)
            .background(Color("brandPrimary"))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
    }
}

struct TextEditButton_Previews: PreviewProvider {
    static var previews: some View {
        TextEditButton()
    }
}
