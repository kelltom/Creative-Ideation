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
    @Binding var showSheet: PreferenceSheet?

    @EnvironmentObject var userAccountViewModel: UserAccountViewModel

    var body: some View {
        ZStack {

            Color("BackgroundColor")

            if userAccountViewModel.showBanner {
                if !userAccountViewModel.updateSuccess {
                    NotificationBanner(image: "exclamationmark.circle.fill",
                                       msg: userAccountViewModel.msg, color: .red)
                } else {
                    NotificationBanner(image: "checkmark.circle.fill",
                                       msg: userAccountViewModel.msg, color: .green)
                }
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

            VStack {

                Spacer()
                if userAccountViewModel.isLoading {
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("brandPrimary")))
                        .scaleEffect(3).padding()
                }

                Text("Change Email")
                    .font(.largeTitle)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.top)

                // displays users email
                VStack(alignment: .leading) {
                    Text("Current Email")
                        .font(.title3)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.leading)
                        .padding(.top)

                    Text(userAccountViewModel.selectedUser?.email ?? "N/A").foregroundColor(.blue)
                        .padding()
                        .frame(width: 550, height: 60, alignment: .leading)
                        .overlay(RoundedRectangle(cornerRadius: 8.0).stroke(Color("StrokeColor")))
                        .font(.title2)
                        .padding(10)

                    // email text input
                    Text("New Email")
                        .font(.title3)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.leading)

                    MenuTextField(title: "Enter New Email ", input: $newEmail)

                    // password confirmation input
                    Text("Enter password ")
                        .font(.title3)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.leading)

                    MenuTextField(
                        title: "Enter Password to Confirm ",
                        input: $currentPasword,
                        secure: true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)

                }
                Button {
                    // save to DB call view model function to update DB
                    userAccountViewModel.updateUserEmail(email: newEmail, password: currentPasword)
                    newEmail = ""
                    currentPasword = ""
                } label: {
                    SubmitButton()
                }
                Spacer()
            }

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
