//
//  UpdateEmailSettings.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-04-07.
//

import SwiftUI

struct UpdateEmailSettings: View {
    @State var newEmail: String = ""
    @State var currentEmail: String = ""

    var body: some View {
        VStack {
            VStack {
                Text("Change email")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .frame(width: .infinity, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            .background(Rectangle()
                            .fill(Color.blue)
                            .frame(width: 500, height: 100, alignment:/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/))
            Spacer()
            VStack(alignment: .leading) {
                Text("Current Email")
                    .font(.title3)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.leading)
                    .padding(.top)
                TextField("current email", text: $currentEmail)
                    .padding()
                    .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    .frame(width: .infinity, height: 50, alignment: .center)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                    .padding()

                Text("New Email")
                    .font(.title3)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.leading)
                TextField("new email", text: $newEmail )
                    .padding()
                    .frame(width: .infinity, height: 50, alignment: .center)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                    .padding()

            }
            Button{
                // save to DB call view model function to update DB
            } label:{
                BigButton(title: "Submit")
            }
            Spacer()
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
