//
//  UpdateEmailSettings.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-04-07.
//

import SwiftUI

struct UpdateEmailSheet: View {
    @State var newEmail: String = ""
    @State var currentEmail: String = ""
    @State var currentPasword: String = ""
    @State private var widthScale: CGFloat = 0.75
    @Binding var showSheet: PreferenceSheet?

    @EnvironmentObject var userAccountViewModel: UserAccountViewModel

    var body: some View {
        ZStack {

            Color("BackgroundColor")

            if userAccountViewModel.isLoading {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("brandPrimary")))
                    .scaleEffect(3).padding()
            }

            VStack {
                HStack {
                    Spacer()
                    Button {
                        showSheet = nil
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Color(.label))
                            .imageScale(.large)
                            .frame(width: 80, height: 80)
                    }
                }
                .padding()
                Spacer()
            }

            GeometryReader { geometry in
                VStack {

                    Spacer()

                    Text("Change Email")
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.top)

                    // displays users email
                    VStack(alignment: .center) {
                        Text("Current Email")
                            .font(.title3)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding(.top)
                            .padding(.bottom, 10)
                            .frame(width: geometry.size.width * widthScale, alignment: .leading)

                        
                        Text(userAccountViewModel.selectedUser?.email ?? "N/A").foregroundColor(.blue)
                            .padding()
                            .frame(width: geometry.size.width * widthScale, height: 60, alignment: .leading)
                            .overlay(RoundedRectangle(cornerRadius: 8.0).stroke(Color("StrokeColor")))
                            .font(.title2)
                            .padding(.bottom, 10)

                        // email text input
                        Text("New Email")
                            .font(.title3)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .frame(width: geometry.size.width * widthScale, alignment: .leading)

                        EditTextField(title: "Enter New Email ", input: $newEmail, geometry: geometry, widthScale: widthScale)

                        // password confirmation input
                        Text("Enter password ")
                            .font(.title3)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .frame(width: geometry.size.width * widthScale, alignment: .leading)


                        EditTextField(
                            title: "Enter Password to Confirm ",
                            input: $currentPasword,
                            secure: true,
                            geometry: geometry,
                            widthScale: 0.75)
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)

                    }
                    Button {
                        // save to DB call view model function to update DB
                        userAccountViewModel.updateUserEmail(email: newEmail, password: currentPasword)
                        newEmail = ""
                        currentPasword = ""
                    } label: {
                        BigButton(title: "Submit", geometry: geometry, widthScale: 0.75)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .banner(data: $userAccountViewModel.bannerData,
                    show: $userAccountViewModel.showBanner)

        }
        .onAppear {
            userAccountViewModel.showBanner = false
        }

    }
}

struct UpdateEmailSettings_Previews: PreviewProvider {
    static var previews: some View {
        UpdateEmailSheet(showSheet: .constant(.email))
            .preferredColorScheme(.dark)
            .environmentObject(UserAccountViewModel())

    }
}
