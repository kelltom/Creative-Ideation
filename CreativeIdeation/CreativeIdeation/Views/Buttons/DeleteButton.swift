//
//  DeleteButton.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-03-17.
//

import SwiftUI

struct DeleteButton: View {
    var image: String = "trash.fill"
    var backgroundColor: Color = .red
    var body: some View {

        HStack {
            Image(systemName: image)
            Text("Delete Team")
                .fontWeight(.bold)
                .font(.body)

        }
        .frame(width: 200, height: 50, alignment: .center)
        .background(backgroundColor)
        .foregroundColor(.white)
        .cornerRadius(10)
        .padding()
        .shadow(radius: 5, x: 5, y: 5)

    }

}

struct DeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteButton()
    }
}
