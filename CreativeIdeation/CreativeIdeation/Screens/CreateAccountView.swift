//
//  CreateAccountView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-02-17.
//

import SwiftUI
import Profanity_Filter

struct CreateAccountView: View {

    // Allows for popping view back to LogInView
    @Binding var showCreateAcc: Bool

    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State private var widthScale: CGFloat = 0.75

    @EnvironmentObject var userAccountViewModel: UserAccountViewModel
    @EnvironmentObject var teamViewModel: TeamViewModel

    var pFilter = ProfanityFilter()

    var body: some View {

        ZStack {
            Color("BackgroundColor")

            if userAccountViewModel.isLoading {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("brandPrimary")))
                    .scaleEffect(3)
            }

            GeometryReader { geometry in
                VStack {

                    Spacer()

                    VStack {

                        Text("Create Account")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()

                        HStack {
                            Text("Enter Full Name")
                                .font(.title3)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            Spacer()
                        }
                        .frame(width: geometry.size.width * widthScale)

                        EditTextField(title: "Full Name", input: $name, geometry: geometry, widthScale: widthScale)

                        HStack {
                            Text("Enter Email Address")
                                .font(.title3)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            Spacer()
                        }
                        .frame(width: geometry.size.width * widthScale)

                        EditTextField(title: "Email Address", input: $email, geometry: geometry, widthScale: widthScale)

                        HStack {
                            Text("Enter Password")
                                .font(.title3)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            Spacer()
                        }
                        .frame(width: geometry.size.width * widthScale)

                        EditTextField(title: "Password", input: $password, secure: true, geometry: geometry, widthScale: widthScale)

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
                            BigButton(title: "Create Account", geometry: geometry, widthScale: widthScale)
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
            .banner(data: $userAccountViewModel.bannerData,
                    show: $userAccountViewModel.showBanner)
        }
        .edgesIgnoringSafeArea(.vertical)
        .onAppear {
            // userAccountViewModel.showBanner = false
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
            // PRIVATE TEAMS ARE DISABLED FOR BETA RELEASE
//            teamViewModel.createTeam(teamName: "Private",
//                                     teamDescription: "Private Team for user.",
//                                     isPrivate: true)
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
