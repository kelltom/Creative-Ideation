//
//  UserPrefView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-25.
//

import SwiftUI

struct UserSettingsView: View {

    @State private var profanityFilter = true

    var title: String = "User Preferences"
    var userName: String = "Kellen Evoy"
    var email: String = "evoyk@sheridancollege.ca"
    var password: String = "******"
    var description: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"

    var body: some View {

        VStack {

            Text(title)
                .font(.system(size: 40))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding(.top)
                .padding()

            VStack {

                Button {
                    // do stuff
                } label: {
                    PreferencePic().padding()
                }

                VStack(alignment: .leading ) {

                    Text("Full Name")
                        .font(.system(size: 25))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                    HStack {

                        Text(userName)
                            .font(.system(size: 18))

                        Spacer()

                        Button {
                            // button functionality
                        } label: {
                            // button design
                            TextEditButton()
                        }
                    }

                    Text("Email")
                        .font(.system(size: 25))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                    HStack {
                        Text(email)
                            .font(.system(size: 18))

                        Spacer()

                        Button {
                            // button functionality
                        } label: {
                            // button design
                            TextEditButton()
                        }
                    }

                    Text("Password")
                        .font(.system(size: 25))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                    HStack {
                        Text(password)
                            .font(.system(size: 18))

                        Spacer()

                        Button {
                            // button functionality
                        } label: {
                            // button design
                            TextEditButton()
                        }
                    }

                }
                .padding()
                .frame(minWidth: 100, maxWidth: 650, maxHeight: 340, alignment: .leading)
                .background(Color(.white))
                .cornerRadius(10)

            }
            .frame(maxWidth: 700, maxHeight: 500, alignment: .center)
            .background(Color("brandPrimary"))
            .cornerRadius(20)

            VStack(alignment: .leading) {

                Text("Display Settings")
                    .font(.system(size: 20))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.gray)
                    .padding(.top)
                    .padding()

                HStack {
                    Toggle("Dark Mode", isOn: $profanityFilter)
                        .padding()

                }

            }
            .frame(maxWidth: 650, maxHeight: 120)

            Divider()
                .frame(maxWidth: 650).background(Color(.gray))

            Spacer()

            Button {
                // do something
            } label: {
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

    }
}

struct UserPrefView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsView(title: "Title",
                         userName: "Username",
                         email: "Email@email.com",
                         password: "*****",
                         description: "Some description here")
    }
}
