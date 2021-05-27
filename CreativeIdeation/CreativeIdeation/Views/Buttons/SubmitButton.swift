//
//  SubmitButton.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-04-07.
//

import SwiftUI

struct SubmitButton: View {
    var body: some View {
        HStack {
            Text("Submit")
                .fontWeight(.bold)
                .font(.body)

        }
        .frame(width: 550, height: 50, alignment: .center)
        .background(Color("brandPrimary"))
        .foregroundColor(.white)
        .cornerRadius(10)
        .padding()
        .shadow(radius: 5, x: 5, y: 5)

    }
}

struct SubmitButton_Previews: PreviewProvider {
    static var previews: some View {
        SubmitButton()
    }
}
