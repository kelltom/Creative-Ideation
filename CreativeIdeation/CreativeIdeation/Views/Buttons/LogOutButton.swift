//
//  LogOutButton.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-04-08.
//

import SwiftUI

struct LogOutButton: View {
    var body: some View {
        HStack {
            Image(systemName: "arrowshape.turn.up.backward.fill")
            Text("Log Out")
                .fontWeight(.bold)
                .font(.body)

        }
        .frame(width: 200, height: 50, alignment: .center)
        .background(Color(.red))
        .foregroundColor(.white)
        .cornerRadius(10)
        .padding()
    }
}

struct LogOutButton_Previews: PreviewProvider {
    static var previews: some View {
        LogOutButton()
    }
}
