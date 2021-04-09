//
//  UserPrefView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-25.
//

import SwiftUI

enum PreferenceSheet: Identifiable {
    case name, email, password

    var id: Int {
        hashValue
    }
}
struct UserSettingsView: View {

    @EnvironmentObject var userAccountViewModel: UserAccountViewModel
    @State var showSheet: PreferenceSheet?
    @State private var darkModeFilter = true

    var title: String = "User Preferences"
    var userName: String = ""
    var email: String = ""
    var password: String = "******"

    var body: some View {

        VStack {

            Text(title)
                .font(.system(size: 40))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding(.top)
                .padding()

            VStack {

                ProfilePic(size: 60)
                    .shadow(color: .black, radius: 4, y: 4)
                    .padding()
                    .contextMenu(ContextMenu(menuItems: {
                        Text("Upload from gallery")
                        Text("Take photo")
                    }))

                VStack(alignment: .leading ) {

                    Text("Full Name")
                        .font(.system(size: 25))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                    HStack {
                        Text(userAccountViewModel.selectedUser?.name ?? "Unknown")
                            .font(.system(size: 18))
                            .padding(.top)
                            .padding(.bottom)

                        Spacer()
                        //edit button for name
                        Button {
                            showSheet = .name
                        } label: {
                            // button design
                            TextEditButton()
                        }

                    }

                    Text("Email")
                        .font(.system(size: 25))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                    HStack {
                        Text(userAccountViewModel.selectedUser?.email ?? "Unknown")
                            .font(.system(size: 18))

                        Spacer()
                        // email text button
                        Button {
                            showSheet = .email
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

                        Button { // edit button for password
                            showSheet = .password
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
                    Toggle("Dark Mode", isOn: $darkModeFilter)
                        .padding()

                }

            }
            .frame(maxWidth: 650, maxHeight: 120)

            Divider()
                .frame(maxWidth: 650).background(Color(.gray))

            Spacer()

            // LogOutButton
            Button {
                userAccountViewModel.signOut()
            } label: {
                LogOutButton()
            }

        }
        .sheet(item: $showSheet) { item in
            switch item {

            case .email:
                UpdateEmailView(showSheet: $showSheet)
                    .environmentObject(self.userAccountViewModel)

            case .password:
                UpdatePasswordView(showSheet: $showSheet) .environmentObject(self.userAccountViewModel)

            case .name:
                UpdateNameView(showSheet: $showSheet)
                    .environmentObject(self.userAccountViewModel)

            }


        }
        .onAppear {
            userAccountViewModel.getCurrentUserInfo()

        }
    }
}

/// Enables the use of the ! operator on binding variables
prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = !$0 }
    )
}

struct UserPrefView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsView()
            .environmentObject(UserAccountViewModel())
    }
}
