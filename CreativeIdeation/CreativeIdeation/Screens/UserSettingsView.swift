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
    @EnvironmentObject var teamViewModel: TeamViewModel
    @EnvironmentObject var groupViewModel: GroupViewModel

    @State var showSheet: PreferenceSheet?
    @State private var darkModeFilter = true

    var title: String = "User Preferences"
    var userName: String = ""
    var email: String = ""
    var password: String = "*********"

    var body: some View {

        ZStack {

            Color("BackgroundColor")

            VStack {

                Text(title)
                    .font(.largeTitle)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
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
                            .font(.title3)
                            .fontWeight(.bold)

                        HStack {
                            Text(userAccountViewModel.selectedUser?.name ?? "Unknown")
                                .font(.title3)

                            Spacer()
                            // edit button for name
                            Button {
                                showSheet = .name
                            } label: {
                                // button design
                                TextEditButton()
                            }

                        }

                        Text("Email")
                            .font(.title3)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                        HStack {
                            Text(userAccountViewModel.selectedUser?.email ?? "Unknown")
                                .font(.title3)

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
                            .font(.title3)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                        HStack {
                            Text(password)
                                .font(.title3)

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
                    .background(Color("BackgroundColor"))
                    .cornerRadius(10)

                }
                .frame(maxWidth: 700, maxHeight: 500, alignment: .center)
                .background(Color("brandPrimary"))
                .cornerRadius(20)

                VStack(alignment: .leading) {

                    Text("Display Settings")
                        .font(.system(size: 20))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.top)
                        .padding()

                    HStack {
                        Toggle("Dark Mode", isOn: $darkModeFilter)
                            .padding()

                    }

                }
                .frame(maxWidth: 650, maxHeight: 120)

                Divider()
                    .frame(maxWidth: 650)
                    .background(Color("FadedColor"))

                Spacer()

            // LogOutButton
            Button {
                userAccountViewModel.signOut()
                teamViewModel.clear()
                groupViewModel.clear()
            } label: {
                LogOutButton()
            }
            NavigationLink(
                destination: LoginView(),
                label: {
                    EmptyView()
                })
            }
            .sheet(item: $showSheet) { item in
                switch item {

                case .email:
                    UpdateEmailSheet(showSheet: $showSheet)
                        .environmentObject(self.userAccountViewModel)

                case .password:
                    UpdatePasswordSheet(showSheet: $showSheet) .environmentObject(self.userAccountViewModel)

                case .name:
                    UpdateNameSheet(showSheet: $showSheet)
                        .environmentObject(self.userAccountViewModel)

                }
            }
            .onAppear {
                userAccountViewModel.getCurrentUserInfo()
            }
        }
        .edgesIgnoringSafeArea(.vertical)
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
            .preferredColorScheme(.dark)
            .environmentObject(UserAccountViewModel())
    }
}
