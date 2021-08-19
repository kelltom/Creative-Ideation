//
//  CreateAccountView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-02-17.
//

import SwiftUI

struct CreateAccountView: View {

    // Allows for popping view back to LogInView
    @Binding var showCreateAcc: Bool

    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""

    @EnvironmentObject var userAccountViewModel: UserAccountViewModel
    @EnvironmentObject var teamViewModel: TeamViewModel

    var body: some View {

        ZStack {
            Color("BackgroundColor")

            if userAccountViewModel.isLoading {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("brandPrimary")))
                    .scaleEffect(3)
            }

            if userAccountViewModel.showBanner {
                if userAccountViewModel.createSuccess {
                    // be nice to show a banner for success here

                } else {
                    NotificationBanner(image: "exclamationmark.circle.fill", msg: userAccountViewModel.msg, color: .red)
                }
            }
            GeometryReader { geometry in
                VStack {

                    Spacer()

                    VStack {

                        Text("Create Account")
                            .padding()
                            .font(.system(size: 40))

                        EditTextField(title: "Full name", input: $name, geometry: geometry)

                        EditTextField(title: "Email address", input: $email, geometry: geometry)

                        EditTextField(title: "Password", input: $password, secure: true, geometry: geometry)

                        // Create Account Link
                        NavigationLink(
                            destination: HomeView(),
                            isActive: $userAccountViewModel.createSuccess,
                            label: {
                                EmptyView()
                            })

                        Button {
                            userAccountViewModel.createAccount(name: name, email: email, password: password)
                        } label: {
                            BigButton(title: "Create Account", geometry: geometry)
                        }

                        // Already have account Button
                        HStack {
                            Text("Already have an account?")
                            Button {
                                self.showCreateAcc = false
                            } label: {
                                Text("Log In.")
                            }
                        }
                        .padding(.top, 20)

                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationBarHidden(true)
            }
        }
        .edgesIgnoringSafeArea(.vertical)
        .onAppear {
            userAccountViewModel.showBanner = false
        }
        .onDisappear {
            userAccountViewModel.showBanner = false
            name = ""
            email = ""
            password = ""
        }
        .onChange(of: userAccountViewModel.createSuccess == true) { _ in
            // When a user account is successfully created, make a Private team
            teamViewModel.getTeams()
            teamViewModel.createTeam(teamName: "Private",
                                     teamDescription: "Private Team for user.",
                                     isPrivate: true)
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView(showCreateAcc: .constant(false))
            .preferredColorScheme(.dark)
            .environmentObject(UserAccountViewModel())
            .environmentObject(TeamViewModel())
    }
}
