//
//  TextEditButton.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-03-17.
//

import SwiftUI

struct TextEditButton: View {

    @State var text: String = "Edit"
    @State var hasPadding: Bool = true

    var body: some View {
        Text(text)
            .fontWeight(.bold)
            .font(.body)
            .frame(width: 100, height: 40, alignment: .center)
            .background(Color("brandPrimary"))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(hasPadding ? 20 : 0)
            .shadow(radius: 5, x: 5, y: 5)
    }
}

struct TextEditButton_Previews: PreviewProvider {
    static var previews: some View {
        TextEditButton()
    }
}
