//
//  UpdateEmailSettings.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-04-07.
//

import SwiftUI

struct UpdateEmailSettings: View {
    var body: some View {
        VStack {
            VStack {
                Text("Change email").foregroundColor(.white)
            }.background(Rectangle()
                            .fill(Color.blue)
                        .frame(width: 500, height: 100, alignment:/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/))

            VStack {
                Text("Current Email")
                Text("Text")
                Text("ffffff")

            }

        }
        .frame(width: 500, height: 500, alignment: .center)
        .background(Color.white).border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)

    }
}

struct UpdateEmailSettings_Previews: PreviewProvider {
    static var previews: some View {
        UpdateEmailSettings()
    }
}
