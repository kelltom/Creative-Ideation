//
//  LoginView.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-02-17.
//

import SwiftUI
import Firebase

struct LoginView: View {

    // Allows for CreateAccount View to jump back to this View
    @State var showCreateAcc = false

    @State var email: String = ""
    @State var password: String = ""
    @State private var widthScale: CGFloat = 0.60

    @EnvironmentObject var userAccountViewModel: UserAccountViewModel
    @EnvironmentObject var teamViewModel: TeamViewModel

    var body: some View {

        NavigationView {

            ZStack {

                Color("BackgroundColor")

                if userAccountViewModel.isLoading {
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("brandPrimary")))
                        .scaleEffect(3).padding()
                }

                GeometryReader { geometry in
                    VStack {

                        Spacer()

                        VStack {

                            Text("Log In")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding()
                            
                            HStack {
                                Text("Enter Email Address")
                                    .font(.title3)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                Spacer()
                            }
                            .frame(width: geometry.size.width * widthScale)
                            
                            EditTextField(title: "Email address", input: $email, geometry: geometry)
                            
                            HStack {
                                Text("Enter Password")
                                    .font(.title3)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                Spacer()
                            }
                            .frame(width: geometry.size.width * widthScale)
                            

                            EditTextField(title: "Password", input: $password, secure: true, geometry: geometry)

                            // Log In Link
                            NavigationLink(
                                destination: HomeView(),
                                isActive: $userAccountViewModel.authSuccess,
                                label: {
                                    EmptyView()
                                })
                                .onChange(of: userAccountViewModel.authSuccess == true) { _ in
                                    teamViewModel.getTeams()
                                }

                            // Log In Button
                            Button {
                                userAccountViewModel.authenticate(email: email, password: password)
                            } label: {
                                BigButton(title: "Log In", geometry: geometry)
                            }
                            .padding(.top)

                            // Create Acc Button
                            HStack {
                                Text("New user?")
                                NavigationLink(destination: CreateAccountView(showCreateAcc: self.$showCreateAcc),
                                               isActive: self.$showCreateAcc) {
                                    Text("Create an Account.")
                                }
                            }
                            .padding(.top, 20)

                            
                            NavigationLink(destination: EmptyView()) {
                                EmptyView()
                            }
                            .hidden()

                        }

                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .navigationBarHidden(true)
                }
                .banner(data: $userAccountViewModel.bannerData,
                        show: $userAccountViewModel.showBanner)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.vertical)
            .onAppear {
                userAccountViewModel.showBanner = false
            }
            .onDisappear {
                email = ""
                password = ""
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
            .environmentObject(UserAccountViewModel())
    }
}

struct GoogleButton: View {

    var body: some View {

        HStack {

            Image("google")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 57)
                .padding(.horizontal, 10)
                .background(Color(.white))
                .cornerRadius(10)
                .padding(.leading, 1)

            Spacer()

            Text("Sign in with Google")
                .offset(x: -25)

            Spacer()

        }
        .frame(width: 550, height: 60, alignment: .center)
        .background(Color(.blue))
        .foregroundColor(.white)
        .cornerRadius(10)
        .font(.title2)
        .padding()
        .shadow(radius: 5, x: 5, y: 5)

    }
}
