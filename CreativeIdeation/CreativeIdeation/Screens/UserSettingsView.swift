//
//  UserPrefView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-25.
//

import SwiftUI

struct UserSettingsView: View {

    @EnvironmentObject var userAccountViewModel: UserAccountViewModel
    @State var showSheet = false
    @State private var darkModeFilter = true

    var title: String = "User Preferences"
    var userName: String = "Kellen Evoy"
    var email: String = "evoyk@sheridancollege.ca"
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

                    }

                    Text("Email")
                        .font(.system(size: 25))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                    HStack {
                        Text(userAccountViewModel.selectedUser?.email ?? "Unknown")
                            .font(.system(size: 18))

                        Spacer()

                        Button {
                            // button functionality
                            self.showSheet.toggle()
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
                    Toggle("Dark Mode", isOn: $darkModeFilter)
                        .padding()


                }

            }
            .frame(maxWidth: 650, maxHeight: 120)

            Divider()
                .frame(maxWidth: 650).background(Color(.gray))

            Spacer()

            NavigationLink(
                destination: LoginView(),
                isActive: $userAccountViewModel.logOutSuccess,
                label: {
                    EmptyView()
                })

            // LogOutButton
            Button {
                //userAccountViewModel.signOut()
            } label: {
                LogOutButton()
            }

        }
        .sheet(isPresented: $showSheet) {
            UpdateEmailSettings(showSheet: $showSheet)
                .environmentObject(self.userAccountViewModel)
        }
        .onAppear {
            userAccountViewModel.getCurrentUserInfo()
        }

    }
}

struct UserPrefView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsView()
            .environmentObject(UserAccountViewModel())
    }
}
